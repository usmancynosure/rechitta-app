/// Asset paths for imagery produced by `tool/generate_images.py`.
///
/// These files are generated with Google Imagen, so they may be absent until
/// you run the script. Use [AppImages.exists]-style guards or a fallback in the
/// UI (the app ships with procedurally-drawn placeholders that work with no
/// assets present).
class AppImages {
  AppImages._();

  // Property renders
  static const String harbourTowerDusk = 'assets/images/renders/harbour_tower_dusk.png';
  static const String vanguardeFacade = 'assets/images/renders/vanguarde_facade.png';
  static const String masterplanAerial = 'assets/images/renders/masterplan_aerial.png';

  // Floor plans
  static const String twoBedTypeA = 'assets/images/floorplans/two_bed_type_a.png';
  static const String twoBedDualEnsuite = 'assets/images/floorplans/two_bed_dual_ensuite.png';

  // Hero / brand backgrounds
  static const String orbBackdropPortrait = 'assets/images/hero/orb_backdrop_portrait.png';
  static const String atmosphereGradient = 'assets/images/hero/atmosphere_gradient.png';

  // Interior lifestyle
  static const String livingHarbourView = 'assets/images/interiors/living_harbour_view.png';
  static const String penthouseEvening = 'assets/images/interiors/penthouse_evening.png';
}
