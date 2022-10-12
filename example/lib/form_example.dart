import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_example/example_pages/age_page.dart';
import 'package:form_example/example_pages/carousel_page.dart';
import 'package:form_example/example_pages/check_page.dart';
import 'package:form_example/example_pages/name_page.dart';

import 'example_pages/date_page.dart';

class FormExample extends ConsumerStatefulWidget {
  const FormExample({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormExampleState();
}

class _FormExampleState extends ConsumerState<FormExample> {
  final FlutterFormController formController = FlutterFormController();

  final String checkPageText = "All entered info: ";

  final ageInputController = FlutterFormInputNumberPickerController(
    id: "age",
    checkPageTitle: (dynamic amount) {
      return "Age: $amount years";
    },
  );

  late final FlutterFormInputCarouselController carouselInputController;

  final List<Map<String, dynamic>> cars = [
    {
      "title": "Mercedes",
      "description": "Mercedes is a car",
    },
    {
      "title": "BMW",
      "description": "BMW is a car",
    },
    {
      "title": "Mazda",
      'description': "Mazda is a car",
    },
  ];

  FlutterFormInputPlainTextController firstNameController =
      FlutterFormInputPlainTextController(
    mandatory: true,
    id: "firstName",
    checkPageTitle: (dynamic firstName) {
      return "First Name: $firstName";
    },
  );

  FlutterFormInputPlainTextController lastNameController =
      FlutterFormInputPlainTextController(
    mandatory: true,
    id: "lastName",
    checkPageTitle: (dynamic lastName) {
      return "Last Name: $lastName";
    },
  );

  FlutterFormInputPlainTextController dateController =
      FlutterFormInputPlainTextController(
    mandatory: true,
    id: "date",
    checkPageTitle: (dynamic date) {
      return "Date: $date";
    },
  );

  @override
  void initState() {
    super.initState();
    carouselInputController = FlutterFormInputCarouselController(
      id: 'carCarousel',
      checkPageTitle: (dynamic index) {
        return cars[index]["title"];
      },
      checkPageDescription: (dynamic index) {
        return cars[index]["description"];
      },
    );
  }

  bool showLastName = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var fontSize = size.height / 40;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: FlutterForm(
            formController: formController,
            options: FlutterFormOptions(
              onFinished: (Map<int, Map<String, dynamic>> results) {
                debugPrint("Final full results: $results");
                Navigator.of(context).pushNamed('/thanks');
              },
              onNext: (int pageNumber, Map<String, dynamic> results) {
                debugPrint("Results page $pageNumber: $results");

                if (pageNumber == 0) {
                  if (results['age'] >= 18) {
                    if (showLastName == false) {
                      showLastName = true;
                      formController.disableCheckingPages();
                    }
                  } else {
                    if (showLastName == true) {
                      showLastName = false;
                      formController.disableCheckingPages();
                    }
                  }
                  setState(() {});
                }
              },
              nextButton: (int pageNumber, bool checkingPages) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: size.height * 0.05,
                    ),
                    child: SizedBox(
                      height: size.height * 0.07,
                      width: size.width * 0.7,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.black,
                          textStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          await formController.autoNextStep();
                        },
                        child: Text(checkingPages ? "Save" : "Next Page"),
                      ),
                    ),
                  ),
                );
              },
              backButton: (int pageNumber, bool checkingPages, int pageAmount) {
                if (pageNumber != 0) {
                  if (!checkingPages || pageNumber >= pageAmount) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          margin: EdgeInsets.only(
                            top: size.height * 0.045,
                            left: size.width * 0.07,
                          ),
                          width: size.width * 0.08,
                          height: size.width * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            color: const Color(0xFFD8D8D8).withOpacity(0.50),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            splashRadius: size.width * 0.06,
                            onPressed: () {
                              formController.previousStep();
                            },
                            icon: const Icon(Icons.chevron_left),
                          )),
                    );
                  }
                }
                return Container();
              },
              pages: [
                FlutterFormPage(
                  child: AgePage(
                    inputController: ageInputController,
                  ),
                ),
                FlutterFormPage(
                  child: NamePage(
                    firstNameController: firstNameController,
                    lastNameController: lastNameController,
                    showLastName: showLastName,
                  ),
                ),
                FlutterFormPage(
                  child: CarouselPage(
                    inputController: carouselInputController,
                    cars: cars,
                  ),
                ),
                FlutterFormPage(
                  child: DatePage(
                    dateController: dateController,
                  ),
                ),
              ],
              checkPage: CheckPageExample()
                  .showCheckpage(context, size, fontSize, checkPageText),
            ),
          ),
        ),
      ),
    );
  }
}
