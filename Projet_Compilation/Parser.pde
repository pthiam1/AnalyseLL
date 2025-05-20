/**
 * Auteur  : THIAM Papa
 * Fichier : Parser.pde
 * Objet   : Implémentation d'un analyseur syntaxique descendant.
 *
 * Description :
 *   - Cette classe gère l'analyse syntaxique d'une séquence de jetons selon une grammaire donnée.
 *   - Utilise une pile pour traiter les symboles terminaux et non terminaux.
 *   - Applique les règles de production, enregistre l'historique des règles appliquées et gère les erreurs de syntaxe.
 *   - Fournit des méthodes pour avancer pas à pas dans l'analyse, vérifier la terminaison et détecter les erreurs.
 */

import java.util.ArrayList;
import java.util.Stack;
import static processing.core.PApplet.println;

class Parser {
  Stack<String> stack = new Stack<String>();
  String[] tokens;
  int index = 0;
  Grammar grammar;
  ArrayList<String> output = new ArrayList<String>();
  ArrayList<String> rulesHistory = new ArrayList<String>();
  String errorMessage = null; 

  /**
   * Constructeur du parser.
   * @param tokens   Liste des jetons à analyser.
   * @param grammar  Grammaire utilisée pour l'analyse.
   */
  Parser(String[] tokens, Grammar grammar) {
    this.tokens = tokens;
    this.grammar = grammar;
    stack.push("$");
    stack.push("P");
  }

  /**
   * Effectue une étape d'analyse syntaxique.
   * Met à jour la pile, l'index, la sortie et l'historique des règles.
   * Gère les erreurs de syntaxe.
   */
  void step() {
    if (stack.isEmpty()) return;

    String top = stack.peek();
    String lookahead = index < tokens.length ? tokens[index] : "$";

    if (top.equals(lookahead)) {
      stack.pop();
      index++;
      output.add("pop");
      rulesHistory.add(""); // Pas de règle pour un pop
    } else if (isTerminal(top)) {
      output.add("pop");
      stack.pop();
      rulesHistory.add(""); // Pas de règle pour un pop
    } else {
      String rule = grammar.getRule(top, lookahead);
      if (rule == null) {
        errorMessage = "Erreur : pas de règle pour (" + top + ", " + lookahead + ")";
        stack.pop();
        return;
      }
      stack.pop();
      String rhs = rule.split("→")[1].trim();
      if (!rhs.equals("ε")) {
        String[] symbols = rhs.split(" ");
        for (int i = symbols.length - 1; i >= 0; i--) {
          stack.push(symbols[i]);
        }
      }
      Integer ruleNum = grammar.getRuleNumber(rule);
      if (ruleNum != null) {
        output.add(ruleNum + ""); // Numéro de la règle appliquée
        rulesHistory.add(ruleNum + " : " + rule); // Historique détaillé
      } else {
        output.add(rule);
        rulesHistory.add(rule);
      }
    }
    println("Pile : " + stack);
    println("Jeton actuel : " + lookahead);
    println("Index : " + index);
    println("Sortie : " + output);
  }

  /**
   * Vérifie si un symbole est terminal.
   * @param symbol Symbole à tester.
   * @return true si terminal, false sinon.
   */
  boolean isTerminal(String symbol) {
    // Un non-terminal est une majuscule éventuellement suivie de '
    return !symbol.matches("[A-Z]′?");
  }

  /**
   * Indique si l'analyse est terminée.
   * @return true si la pile est vide et tous les jetons ont été consommés.
   */
  boolean isFinished() {
    return stack.isEmpty() && index >= tokens.length;
  }

  /**
   * Retourne le message d'erreur courant, s'il existe.
   * @return Message d'erreur ou null.
   */
  String getErrorMessage() {
    return errorMessage;
  }
}
