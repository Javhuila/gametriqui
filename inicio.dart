import 'package:flutter/material.dart';
import 'package:flutter_second/design/color.dart';

class CasaIni extends StatefulWidget {
  const CasaIni({Key? key}) : super(key: key);

  @override
  State<CasaIni> createState() => _CasaIniState();
}

// () llama a una función.
// [] indica el valor inicial en la lista.
// . conlleva a una propiedad que tenga dicha expresión
class _CasaIniState extends State<CasaIni> {
  // Añadiendo las variables necesarias para el game
  String valor = "X";
  bool juegoTerminado = false;
  int turno = 0;
  String resultado = "";
  // Con este listado, servira para marcar las multiples combinaciones
  // y diferentes posiciones que se coloquen en el juego.
  // Tener en cuenta que para ganar se completa
  // Row[1,2,3] Col[1,2,3] Diagonal[1,2,3]
  List<int> puntajeboard = [0, 0, 0, 0, 0, 0, 0, 0];

  //Juego
  Game game = Game();

  //Iniciamos la función con un estado
  @override
  void initState() {
    super.initState();
    game.tablero = Game.iniitGameTablero();
  }

  @override
  Widget build(BuildContext context) {
    // Definimos el tamaño del tablero
    double tamanoTablero = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            // toUpperCase sirve para convertir cualquier texto en mayúsculas
            " El turno es de ${valor}.".toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 58,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Ahora haremos el diseño del tablero
          SizedBox(
              width: tamanoTablero,
              height: tamanoTablero,
              child: GridView.count(
                // ~/ es un operador que permite usar un double y arroja
                // un resultado de int
                padding: const EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                crossAxisCount: Game.tablerolenth ~/ 3,
                children: List.generate(Game.tablerolenth, (index) {
                  return InkWell(
                    onTap: juegoTerminado
                        // ? es igual al if
                        // : es igual al else
                        ? null
                        : () {
                            // Cargaremos un estado, servirá cuando demos click sobre cualquier
                            // bloque en el tablero añada un valor en el tablero.
                            // Ahora, anadiremos el segundo jugador con una condición.
                            // == indica que es igual.
                            // !dart indica una inversión de la expresión de verdadero a falso y viceversa
                            // Ej: bool manzana = true/false.
                            // !manzana = false/true.
                            if (game.tablero![index] == "") {
                              setState(() {
                                game.tablero![index] = valor;
                                // ++variable significa la suma de la variable + 1
                                // y retorna la variable
                                turno++;
                                // Declaramos de como se gana
                                juegoTerminado = game.ganadorTriunfa(
                                    valor, index, puntajeboard, 3);
                                if (juegoTerminado) {
                                  resultado = "$valor es el ganador";
                                } else if (!juegoTerminado && turno == 9) {
                                  resultado = "Hay un empate!";
                                  juegoTerminado = true;
                                }
                                if (valor == "X")
                                  valor = "O";
                                else
                                  valor = "X";
                              });
                            }
                          },
                    child: Container(
                      width: Game.bloquesSize,
                      height: Game.bloquesSize,
                      decoration: BoxDecoration(
                        color: MainColor.secundaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                          child: Text(
                        game.tablero![index],
                        style: TextStyle(
                          color: game.tablero![index] == "X"
                              ? Colors.blue
                              : Colors.pink,
                          fontSize: 60,
                        ),
                      )),
                    ),
                  );
                }),
              )),
          const SizedBox(height: 25),
          Text(
            resultado,
            style: const TextStyle(color: Colors.white, fontSize: 54),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Con este botón y este estado, lo reiniciaremos
              setState(() {
                game.tablero = Game.iniitGameTablero();
                // Es posible que no concuerde el turno con la figura,
                // lo reiniciaremos tambien.
                valor = "X";
                turno = 0;
                resultado = "";
                puntajeboard = [0, 0, 0, 0, 0, 0, 0, 0];
              });
            },
            icon: const Icon(Icons.replay),
            label: const Text("Repetir el juego"),
          ),
        ],
      ),
    );
  }
}

// Jugadores
class Player {
  static const x = "X";
  static const o = "O";
  static const empate = "";
}

//Logica de la jugabilidad
class Game {
  //El tablero debe ser de 3x3
  static final tablerolenth = 9;
  //El double maneja decimales, si no se especifica, dará error
  static final bloquesSize = 100.0;

  // En caso de empate
  List<String>? tablero;

  static List<String>? iniitGameTablero() =>
      List.generate(tablerolenth, (index) => Player.empate);

  // Improvisemos el código para el ganador.
  // Se usa la variable "puntajeboard"
  bool ganadorTriunfa(
      String player, int index, List<int> puntajeboard, int tamanogrid) {
    // Empecemos a declarar las filas y columnas
    // ~/ Divide y regresa un int
    // % Es un modulo que permite retornar el resultado de una división
    int row = index ~/ 3;
    int col = index % 3;
    int punt = player == "X" ? 1 : -1;

    puntajeboard[row] + punt;
    // += sirve para sumar la variable misma más otra.
    // += a = a + b
    puntajeboard[tamanogrid + col] += punt;
    if (row == col) puntajeboard[2 * tamanogrid] += punt;
    if (tamanogrid - 1 - col == row) puntajeboard[2 * tamanogrid + 1] += punt;

    // Implementemos cuando tenga 3 en el tablero
    if (puntajeboard.contains(3) || puntajeboard.contains(-3)) {
      return true;
    }

    // Error si es falso
    return false;
  }
}
