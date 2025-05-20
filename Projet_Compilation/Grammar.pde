/**
 * Auteur  : THIAM Papa
 * Fichier : Grammar.pde
 * Objet   : Gestion de la grammaire du langage source pour l'analyse syntaxique.
 *
 * Description :
 *   - Cette classe définit la structure de la grammaire et les règles de production du langage.
 *   - Utilise une table de hachage pour stocker les règles de production, associées à un non-terminal et un terminal.
 *   - Gère la numérotation automatique des règles pour faciliter le suivi lors de l'analyse.
 *   - Fournit des méthodes pour ajouter une règle, récupérer une règle selon un couple (non-terminal, terminal)
 *     et obtenir le numéro associé à une règle.
 *   - La grammaire est initialisée avec l'ensemble des règles nécessaires à l'analyse du langage cible.
 *   - Utilisée par l'analyseur syntaxique (Parser) pour déterminer les actions à effectuer lors de l'analyse.
 */

class Grammar {
  HashMap<String, HashMap<String, String>> table;
  HashMap<String, Integer> rulesNumbers;

  Grammar() {
    table = new HashMap<String, HashMap<String, String>>();
    rulesNumbers = new HashMap<String, Integer>();
    initTable();
  }

  int ruleCount = 1; // Compteur de règles

  void initTable() {
    // Initialisation de la table de grammaire avec les règles de production du projet
    addRule("P", "debut", "P → debut S fin");

    addRule("S", "id", "S → I R");
    addRule("S", ";", "S → I R");
    addRule("S", "fin", "S → I R");

    addRule("R", ";", "R → ; I R");
    addRule("R", "fin", "R → ε");

    addRule("I", "id", "I → id := E");
    addRule("I", ";", "I → ε");
    addRule("I", "fin", "I → ε");

    addRule("E", "id", "E → T E′");
    addRule("E", "(", "E → T E′");
    addRule("E", "nb", "E → T E′");

    addRule("E′", "+", "E′ → + T E′");
    addRule("E′", ";", "E′ → ε");
    addRule("E′", "fin", "E′ → ε");
    addRule("E′", ")", "E′ → ε");

    addRule("T", "id", "T → F T′");
    addRule("T", "(", "T → F T′");
    addRule("T", "nb", "T → F T′");

    addRule("T′", "*", "T′ → * F T′");
    addRule("T′", "+", "T′ → ε");
    addRule("T′", ";", "T′ → ε");
    addRule("T′", ")", "T′ → ε");
    addRule("T′", "fin", "T′ → ε");

    addRule("F", "id", "F → id");
    addRule("F", "(", "F → ( E )");
    addRule("F", "nb", "F → nb");
  }

  /**
   * Ajoute une règle de production à la grammaire et lui assigne un numéro unique.
   * @param nonTerm Symbole non terminal
   * @param term    Symbole terminal
   * @param rule    Règle de production sous forme de chaîne
   */
  void addRule(String nonTerm, String term, String rule) {
    if (!table.containsKey(nonTerm)) {
      table.put(nonTerm, new HashMap<String, String>());
    }
    table.get(nonTerm).put(term, rule);
    // Numérote chaque règle dans l'ordre d'ajout
    if (!rulesNumbers.containsKey(rule)) {
      rulesNumbers.put(rule, ruleCount++);
    }
  }

  /**
   * Récupère la règle de production associée à un couple (non-terminal, terminal).
   * @param nonTerminal Symbole non terminal
   * @param terminal    Symbole terminal
   * @return            Règle de production correspondante ou null si absente
   */
  String getRule(String nonTerminal, String terminal) {
    HashMap<String, String> row = table.get(nonTerminal);
    if (row == null) return null;
    return row.getOrDefault(terminal, null);
  }

  /**
   * Retourne le numéro associé à une règle de production.
   * @param rule Règle de production
   * @return     Numéro de la règle ou null si absente
   */
  Integer getRuleNumber(String rule) {
    return rulesNumbers.get(rule);
  }
}
