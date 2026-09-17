#!/usr/bin/env python3
"""
Generate high-quality imagery for the Rechitta Flutter app using Google Imagen.

Matches the rechitta.com aesthetic: dark, premium, coastal-luxury real estate.
Images are written straight into the app's asset folders so the app can use them.

Usage
-----
    pip install -r tool/requirements.txt
    # put GEMINI_API_KEY=... (or GOOGLE_API_KEY=...) in a .env file at repo root
    python tool/generate_images.py                 # generate everything
    python tool/generate_images.py --category hero # just one category
    python tool/generate_images.py --only harbour_tower_dusk
    python tool/generate_images.py --model imagen-3.0-generate-002
    python tool/generate_images.py --overwrite     # regenerate existing files

Categories: renders, floorplans, hero, interiors
"""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

# ---- Paths -----------------------------------------------------------------

REPO_ROOT = Path(__file__).resolve().parent.parent
ASSETS = REPO_ROOT / "assets" / "images"

# Gemini image models used through generate_content (Developer API / AI Studio
# keys). Imagen's generate_images endpoint is Vertex-only, so we use these.
# The script falls back to the next model if one is unavailable for your key.
DEFAULT_MODELS = [
    "gemini-2.5-flash-image",
    "gemini-2.5-flash-image-preview",
    "gemini-2.0-flash-preview-image-generation",
]

# A shared style suffix keeps every image on-brand.
BRAND_STYLE = (
    "cinematic, ultra detailed, high dynamic range, professional photography, "
    "elegant and premium, moody dark tones with cool blue accents, sharp focus, 8k"
)

NEGATIVE = "text, watermark, logo, people faces, distorted, low quality, cartoon, clutter"


# ---- Image catalogue -------------------------------------------------------
# Each entry: (category, filename_stem, aspect_ratio, prompt)

IMAGES: list[tuple[str, str, str, str]] = [
    # --- Property renders (for the property cards) ---
    ("renders", "harbour_tower_dusk", "4:3",
     "Architectural exterior render of a modern luxury coastal residential tower "
     "in Dubai, curved cantilevered balconies, warm timber and white concrete "
     "facade, floor-to-ceiling glass, reflecting a calm marina at golden-hour "
     "dusk, zero-edge infinity pool on a podium"),
    ("renders", "vanguarde_facade", "4:3",
     "Close architectural photograph of a premium residential building facade, "
     "rhythmic vertical fins, bronze metal accents, glowing interior lights at "
     "blue hour, coastal skyline background"),
    ("renders", "masterplan_aerial", "16:9",
     "Aerial twilight view of an upscale waterfront masterplan development, "
     "landscaped promenade, yachts in a marina, illuminated towers, calm sea"),

    # --- Floor plans ---
    ("floorplans", "two_bed_type_a", "1:1",
     "Clean minimalist top-down architectural floor plan of a luxury 2-bedroom "
     "apartment, precise furniture layout, kitchen, ensuite bathrooms, large "
     "balcony marked 'Harbour Facing', thin crisp line work on a light warm-grey "
     "background, professional real-estate floor plan graphic"),
    ("floorplans", "two_bed_dual_ensuite", "1:1",
     "Top-down architectural floor plan of a dual-ensuite 2-bedroom residence, "
     "open-plan living and dining, walk-in wardrobes, minimalist line drawing, "
     "subtle room shading, light background, premium property brochure style"),

    # --- Hero / brand backgrounds (portrait for phone screens) ---
    ("hero", "orb_backdrop_portrait", "9:16",
     "Abstract premium background, deep pure black, a single softly glowing "
     "electric-blue orb of light with a diffuse halo and subtle particles, "
     "smooth gradient, lots of negative space, elegant tech brand aesthetic"),
    ("hero", "atmosphere_gradient", "9:16",
     "Dark atmospheric gradient background, black to deep midnight blue, faint "
     "volumetric glow rising from the bottom, cinematic haze, minimalist, "
     "premium fintech style, no objects"),

    # --- Interior lifestyle shots ---
    ("interiors", "living_harbour_view", "16:9",
     "Luxury minimalist apartment living room interior at dusk, floor-to-ceiling "
     "windows overlooking a lit harbour and skyline, warm neutral palette, "
     "designer furniture, soft ambient lighting, architectural digest style"),
    ("interiors", "penthouse_evening", "16:9",
     "Elegant penthouse interior in the evening, open-plan kitchen and lounge, "
     "marble and warm wood finishes, panoramic sea view, cove lighting, "
     "high-end real estate photography"),
]


# ---- Env + client ----------------------------------------------------------

def load_env() -> str:
    """Load .env and return the Gemini/Google API key."""
    try:
        from dotenv import load_dotenv
        load_dotenv(REPO_ROOT / ".env")
    except ImportError:
        # python-dotenv is optional; env vars may already be exported.
        pass

    key = os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")
    if not key:
        sys.exit(
            "ERROR: No API key found. Put GEMINI_API_KEY=... (or GOOGLE_API_KEY=...) "
            "in a .env file at the repo root, or export it in your shell."
        )
    return key


def make_client(api_key: str):
    try:
        from google import genai  # noqa: F401
    except ImportError:
        sys.exit(
            "ERROR: google-genai is not installed.\n"
            "Run:  pip install -r tool/requirements.txt"
        )
    from google import genai
    return genai.Client(api_key=api_key)


# ---- Generation ------------------------------------------------------------

def _build_config(types, aspect: str):
    """GenerateContentConfig requesting an image, with aspect ratio when the
    installed SDK supports image_config (older versions do not)."""
    kwargs = {
        "response_modalities": ["IMAGE"],
    }
    try:
        kwargs["image_config"] = types.ImageConfig(aspect_ratio=aspect)
    except (AttributeError, TypeError):
        pass  # older SDK: aspect ratio is steered via the prompt text instead
    try:
        return types.GenerateContentConfig(**kwargs)
    except TypeError:
        # response_modalities unsupported name? fall back to minimal config.
        return types.GenerateContentConfig(response_modalities=["IMAGE"])


def _extract_image_bytes(resp) -> bytes | None:
    for cand in getattr(resp, "candidates", None) or []:
        content = getattr(cand, "content", None)
        for part in getattr(content, "parts", None) or []:
            inline = getattr(part, "inline_data", None)
            if inline is not None and getattr(inline, "data", None):
                return inline.data
    return None


def generate_one(client, models: list[str], prompt: str, aspect: str, out_path: Path) -> bool:
    """Try each model until one succeeds. Returns True on success."""
    from google.genai import types

    # Steer composition via text too, since not every SDK/model honours
    # image_config aspect ratios.
    full_prompt = (
        f"{prompt}. {BRAND_STYLE}. Composition aspect ratio {aspect}. "
        f"Avoid: {NEGATIVE}."
    )
    last_err: Exception | None = None

    for model in models:
        try:
            resp = client.models.generate_content(
                model=model,
                contents=full_prompt,
                config=_build_config(types, aspect),
            )
            data = _extract_image_bytes(resp)
            if not data:
                last_err = RuntimeError("no image in response (possibly filtered)")
                continue

            out_path.parent.mkdir(parents=True, exist_ok=True)
            out_path.write_bytes(data)
            print(f"  ✓ {out_path.relative_to(REPO_ROOT)}  ({model}, {aspect})")
            return True
        except Exception as exc:  # noqa: BLE001 - surface and try next model
            last_err = exc
            msg = str(exc).splitlines()[0][:140]
            print(f"  … {model} failed: {msg}")

    print(f"  ✗ FAILED {out_path.name}: {last_err}")
    return False


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate Rechitta app imagery with Imagen.")
    parser.add_argument("--category", choices=["renders", "floorplans", "hero", "interiors"],
                        help="Only generate one category.")
    parser.add_argument("--only", help="Only generate the image with this filename stem.")
    parser.add_argument("--model", help="Force a specific Imagen model id.")
    parser.add_argument("--overwrite", action="store_true",
                        help="Regenerate images even if the file already exists.")
    parser.add_argument("--list", action="store_true", help="List the catalogue and exit.")
    args = parser.parse_args()

    if args.list:
        for cat, stem, aspect, _ in IMAGES:
            print(f"{cat:11} {stem:26} {aspect}")
        return

    jobs = [
        job for job in IMAGES
        if (not args.category or job[0] == args.category)
        and (not args.only or job[1] == args.only)
    ]
    if not jobs:
        sys.exit("No images match those filters. Use --list to see the catalogue.")

    models = [args.model] if args.model else DEFAULT_MODELS

    api_key = load_env()
    client = make_client(api_key)

    print(f"Generating {len(jobs)} image(s) into {ASSETS.relative_to(REPO_ROOT)}/\n")
    ok = 0
    skipped = 0
    for cat, stem, aspect, prompt in jobs:
        out_path = ASSETS / cat / f"{stem}.png"
        if out_path.exists() and not args.overwrite:
            print(f"  · skip (exists) {out_path.relative_to(REPO_ROOT)}")
            skipped += 1
            continue
        print(f"[{cat}] {stem}")
        if generate_one(client, models, prompt, aspect, out_path):
            ok += 1

    print(f"\nDone. {ok} generated, {skipped} skipped, "
          f"{len(jobs) - ok - skipped} failed.")
    if ok:
        print("Run `flutter pub get` if you added new asset folders, then hot-restart.")


if __name__ == "__main__":
    main()
