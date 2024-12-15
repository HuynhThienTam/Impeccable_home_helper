import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class ProcessWidget extends StatelessWidget {
  final List<String> processes;
  final List<String> doneProcesses;
  final List<String> currentProcesses;
  final int currentProcess;

  const ProcessWidget({
    Key? key,
    required this.processes,
    required this.doneProcesses,
    required this.currentProcesses,
    required this.currentProcess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Handle canceled cases
    if (currentProcess == -1 || currentProcess == -2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth / 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                processes.length * 2 - 1,
                (index) {
                  if (index.isEven) {
                    // Dot
                    return Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: silverGrayColor,
                        shape: BoxShape.circle,
                      ),
                    );
                  } else {
                    // Line
                    return Expanded(
                      child: Container(
                        height: 2,
                        color: silverGrayColor,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            currentProcess == -1 ? "Cancelled by customer" : "Cancelled by you",
            style: TextStyle(
              color: silverGrayColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // Normal behavior
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row for dots and lines
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth / 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              processes.length * 2 - 1,
              (index) {
                if (index.isEven) {
                  // Dot
                  int dotIndex = index ~/ 2;
                  return Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: dotIndex <= currentProcess
                          ? crimsonRedColor
                          : silverGrayColor,
                      shape: BoxShape.circle,
                    ),
                  );
                } else {
                  // Line
                  return Expanded(
                    child: Container(
                      height: 2,
                      color: index ~/ 2 < currentProcess
                          ? crimsonRedColor
                          : silverGrayColor,
                    ),
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Row for process names
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            processes.length,
            (index) {
              return Container(
                width: 80, // Set a fixed width, adjust as needed
                alignment: Alignment.center,
                child: Text(
                  index < currentProcess
                      ? doneProcesses[index]
                      : index == currentProcess
                          ? currentProcesses[index]
                          : processes[index],
                  style: TextStyle(
                    color: index <= currentProcess
                        ? crimsonRedColor
                        : silverGrayColor,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// class ProcessWidget extends StatelessWidget {
//   final List<String> processes;
//   final List<String> doneProcesses;
//   final List<String> currentProcesses;
//   final int currentProcess;

//   const ProcessWidget({
//     Key? key,
//     required this.processes,
//     required this.doneProcesses,
//     required this.currentProcesses,
//     required this.currentProcess,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Row for dots and lines
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: List.generate(
//             processes.length * 2 - 1,
//             (index) {
//               if (index.isEven) {
//                 // Dot
//                 int dotIndex = index ~/ 2;
//                 return Container(
//                   width: 20,
//                   height: 20,
//                   decoration: BoxDecoration(
//                     color: dotIndex <= currentProcess ? crimsonRedColor: silverGrayColor,
//                     shape: BoxShape.circle,
//                   ),
//                 );
//               } else {
//                 // Line
//                 return Expanded(
//                   child: Container(
//                     height: 2,
//                     color: index ~/ 2 < currentProcess ? crimsonRedColor : silverGrayColor,
//                   ),
//                 );
//               }
//             },
//           ),
//         ),
//         const SizedBox(height: 16),
//         // Row for process names
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(
//             processes.length,
//             (index) => Text(
//               index < currentProcess
//                   ? doneProcesses[index]
//                   : index == currentProcess
//                       ? currentProcesses[index]
//                       : processes[index],
//               style: TextStyle(
//                 color: index <= currentProcess ? crimsonRedColor: silverGrayColor,
//                 fontSize: 12,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
