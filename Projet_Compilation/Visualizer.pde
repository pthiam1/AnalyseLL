/**
 * Auteur  : THIAM Papa
 * Fichier : Visualizer.pde
 * Objet   : Visualisation graphique de l'état de l'analyseur syntaxique.
 *
 * Description :
 *   - Cette classe est responsable de l'affichage de la pile, de l'entrée restante, de la sortie,
 *     des règles appliquées et des erreurs éventuelles lors de l'analyse syntaxique.
 *   - Utilise la bibliothèque Processing pour le rendu graphique.
 *   - La méthode display() est appelée à chaque itération de la boucle de dessin pour mettre à jour l'affichage.
 *   - La méthode stackToArray() convertit la pile en tableau pour l'affichage.
 *   - Permet de suivre visuellement le processus d'analyse syntaxique et facilite la détection des erreurs.
 *   - La classe est initialisée avec une instance de Parser, qui contient l'état courant de l'analyseur.
 */

class Visualizer {
  Parser parser;
  String filename;

  Visualizer(Parser parser, String filename) {
    this.parser = parser;
    this.filename = filename;
  }

  void display() {
    background(245, 248, 255);

    // En-tête avec mon nom et titre principal
    fill(60, 90, 170);
    textSize(22);
    textAlign(LEFT, TOP);
    text("THIAM Papa - Analyseur Syntaxique", 20, 10);

    // Encadré du nom du fichier testé (sur la même ligne que le titre, à droite)
    int fileBoxW = 340;
    int fileBoxH = 32;
    int fileBoxX = 420; // Ajusté pour être sur la même ligne que le titre
    int fileBoxY = 10;
    fill(230, 240, 255, 230);
    stroke(80, 120, 200, 180);
    strokeWeight(2);
    rect(fileBoxX, fileBoxY, fileBoxW, fileBoxH, 10);
    noStroke();
    fill(40, 60, 120);
    textSize(17);
    textAlign(LEFT, CENTER);
    text("Fichier testé : " + filename, fileBoxX + 16, fileBoxY + fileBoxH/2);
    textAlign(LEFT, TOP);

    // Encadré pile
    fill(255, 255, 255, 230);
    stroke(80, 120, 200, 180);
    strokeWeight(2);
    rect(20, 60, 250, 90, 12); // Décalé vers le haut
    noStroke();
    fill(60, 90, 170);
    textSize(15);
    text("Pile :", 35, 80);
    fill(30, 30, 30);
    textSize(13);
    text(join(stackToArray(parser.stack), " "), 100, 80);

    // Encadré entrée
    fill(255, 255, 255, 230);
    stroke(80, 120, 200, 180);
    strokeWeight(2);
    rect(290, 60, 480, 90, 12); // Décalé vers le haut
    noStroke();
    fill(60, 90, 170);
    textSize(15);
    text("Entrée :", 310, 80);
    fill(30, 30, 30);
    textSize(13);
    String remaining = "";
    for (int i = parser.index; i < parser.tokens.length; i++) {
      remaining += parser.tokens[i] + " ";
    }
    text(remaining, 380, 80);

    // Encadré sortie (à gauche, HAUTEUR AUGMENTÉE)
    fill(255, 255, 255, 230);
    stroke(80, 120, 200, 180);
    strokeWeight(2);
    rect(20, 170, 360, 650, 12); // Remonté
    noStroke();
    fill(60, 90, 170);
    textSize(15);
    text("Sortie :", 35, 190);

    int y1 = 220;
    textSize(13);
    int maxLines = 28;
    for (int i = 0; i < parser.output.size() && i < maxLines; i++) {
      if (i % 2 == 0) {
        fill(230, 240, 255, 120);
        rect(30, y1 - 2, 340, 18, 4);
      }
      fill(40, 60, 120);
      text(parser.output.get(i), 55, y1);
      y1 += 20;
    }

    // Encadré règles appliquées (à droite, HAUTEUR AUGMENTÉE)
    fill(255, 255, 255, 230);
    stroke(80, 120, 200, 180);
    strokeWeight(2);
    rect(400, 170, 370, 650, 12); // Remonté
    noStroke();
    fill(60, 90, 170);
    textSize(15);
    text("Règle appliquée :", 415, 190);

    int y2 = 220;
    textSize(13);
    for (int i = 0; i < parser.rulesHistory.size() && i < maxLines; i++) {
      if (i % 2 == 0) {
        fill(230, 240, 255, 120);
        rect(410, y2 - 2, 340, 18, 4);
      }
      fill(40, 60, 120);
      text(parser.rulesHistory.get(i), 435, y2);
      y2 += 20;
    }

    // Encadré erreurs et état (remonté)
    textSize(15);
    String errorText = parser.errorMessage != null ? "Erreur : " + parser.errorMessage : "Pas d'erreur";
    String statusText = parser.isFinished() ? "Analyse terminée" : "";
    float maxBoxWidth = 700;
    int errorLines = 1 + (int)(textWidth(errorText) / maxBoxWidth);
    int statusLines = statusText.length() > 0 ? 1 + (int)(textWidth(statusText) / maxBoxWidth) : 0;
    int totalLines = errorLines + statusLines;
    int boxHeight = 60 + (totalLines - 1) * 20;

    fill(255, 255, 255, 230);
    stroke(200, 80, 80, 180);
    strokeWeight(2);
    rect(20, 840, 750, boxHeight, 12); // Remonté
    noStroke();

    fill(parser.errorMessage != null ? color(200, 40, 40) : color(40, 150, 60));
    textAlign(LEFT, TOP);
    text(errorText, 40, 860, maxBoxWidth, boxHeight - 10);

    if (parser.isFinished()) {
      fill(0, 150, 0);
      textAlign(LEFT, TOP);
      text(statusText, 40, 860 + errorLines * 20, maxBoxWidth, boxHeight - 10);
    }
    textAlign(LEFT, BASELINE);

    // Légende et informations complémentaires 
    fill(80, 80, 80, 180);
    textSize(12);
    text("Espace : pas à pas   |   a : mode auto   |   p : pause   |   q : quitter", 20, 970);
    text("THIAM Papa - Version 1.0", 20, 985);
  }

  /**
   * Convertit la pile en tableau de chaînes pour l'affichage.
   * @param s Pile à convertir
   * @return  Tableau de chaînes représentant la pile
   */
  String[] stackToArray(Stack<String> s) {
    String[] arr = new String[s.size()];
    for (int i = 0; i < s.size(); i++) {
      arr[i] = s.get(i);
    }
    return arr;
  }
}
