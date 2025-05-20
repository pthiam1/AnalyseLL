/**
 * Auteur  : THIAM Papa
 * Fichier : Projet_Compilation.pde
 * Objet   : Analyseur syntaxique pour un langage de programmation simple.
 *
 * Description :
 *   - La fonction setup() charge le code source depuis un fichier texte, effectue la tokenisation,
 *     puis initialise la grammaire, le parser et le visualiseur.
 *   - La fonction draw() met à jour l'affichage en fonction de l'état du parser.
 *   - La fonction keyPressed() permet de contrôler l'analyseur (pas à pas, mode auto, pause, quitter).
 *   - La fonction tokenize() transforme le code source en une liste de jetons pour l'analyse syntaxique.
 *
 * Contrôles clavier :
 *   - Espace : Avancer d'un pas dans l'analyse
 *   - a      : Activer/désactiver le mode automatique
 *   - p      : Mettre en pause/reprendre l'analyse
 *   - q      : Quitter le programme
 */

Parser parser;
Grammar grammar;
Visualizer visualizer;

// Variables pour le mode automatique
int autoStepDelay = 30;   // Nombre de frames entre deux étapes automatiques
int lastStepFrame = 0;
boolean autoMode = false;
boolean paused = false;   // Indique si l'analyse est en pause

String filename = "data/prog_1.txt";

void setup() {
  size(800, 1000); // Taille de la fenêtre

  String[] source = loadStrings(filename);
  String joined = join(source, " ");
  String[] tokens = tokenize(joined);
  grammar = new Grammar();
  parser = new Parser(tokens, grammar);
  visualizer = new Visualizer(parser, filename);
}

void draw() {
  background(255);

  // Affichage de la boîte d'information (contrôles, état, erreurs)
  int boxW = 320;
  int boxH = 110;
  int infoX = width - boxW - 20;
  int infoY = height - boxH - 20;
  int pad = 10;
  int lh = 16;

  // Boîte d'information avec fond coloré et coins arrondis
  fill(230, 240, 255, 230);
  stroke(80, 120, 200);
  strokeWeight(2);
  rect(infoX, infoY, boxW, boxH, 16);
  noStroke();
  fill(40, 60, 120);
  textSize(11);
  text("a : mode auto", infoX + pad, infoY + pad + lh * 0);
  text("' ' : pas à pas", infoX + pad, infoY + pad + lh * 1);
  text("q : quitter", infoX + pad, infoY + pad + lh * 2);
  text("p : pause", infoX + pad, infoY + pad + lh * 3);
  fill(180, 30, 30);
  text("Erreur : " + parser.getErrorMessage(), infoX + pad, infoY + pad + lh * 3);
  fill(40, 60, 120);
  text("Auto : " + (autoMode ? "Activé" : "Désactivé"), infoX + pad, infoY + pad + lh * 4);
  text("Auteur : THIAM Papa", infoX + pad, infoY + pad + lh * 5);
  text("Version : 1.0", infoX + pad, infoY + pad + lh * 6);
  textSize(10);

  visualizer.display();

  // Exécution automatique si activée et non en pause
  if (autoMode && !paused && frameCount - lastStepFrame >= autoStepDelay) {
    parser.step();
    lastStepFrame = frameCount;
  }
}

void keyPressed() {
  if (key == ' ' && parser != null && !autoMode && !paused) {
    parser.step();
  } else if (key == 'a' && parser != null) {
    autoMode = !autoMode;
    if (autoMode) {
      lastStepFrame = frameCount;
    }
  } else if (key == 'p' || key == 'P') {
    paused = !paused;
  } else if (key == 'q') {
    exit();
  }
}

/**
 * Tokenise une chaîne de caractères en une liste de jetons pour l'analyse syntaxique.
 * Remplace les opérateurs et séparateurs par des espaces pour faciliter le découpage.
 */
String[] tokenize(String input) {
  input = input.replaceAll(";", " ;")
               .replaceAll(":=", " := ")
               .replaceAll("\\(", " ( ")
               .replaceAll("\\)", " ) ")
               .replaceAll("\\+", " + ")
               .replaceAll("\\*", " * ");
  String[] rawTokens = splitTokens(input);
  ArrayList<String> tokens = new ArrayList<String>();
  for (String t : rawTokens) {
    if (t.matches("\\d+")) {
      tokens.add("nb");
    } else if (t.matches("[a-zA-Z]\\w*") && !t.equals("debut") && !t.equals("fin")) {
      tokens.add("id");
    } else {
      tokens.add(t);
    }
  }
  return tokens.toArray(new String[0]);
}
