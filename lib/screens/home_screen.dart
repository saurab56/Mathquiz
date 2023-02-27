import 'package:flutter/material.dart';
import 'package:kuize_app/screens/result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController controller = PageController();
  final key = GlobalKey<FormState>();
  TextEditingController answerController = TextEditingController();
  int currentIndex = 0;

  List<String> questions = [
    '2 + 3  = ',
    '9 + 9 = ',
    '3 * 3  = ',
    '10 / 2 = ',
    '1 - 1 = '
  ];
  List<String> correctAnswerList = ['5', '18', '9', '5', '0'];

  List<String> userAnswerList = [];

  toNextPage() async {
    await controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    setState(() {
      answerController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
      ),
      body: Form(
        key: key,
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: questions.length,
                itemBuilder: (context, index) => QuizWidget(
                  onTap: () {
                    if (key.currentState!.validate()) {
                      setState(() {
                        userAnswerList.add(answerController.text);
                      });
                      if ((currentIndex + 1) >= questions.length) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultScreen(
                              questions: questions,
                              correctAns: correctAnswerList,
                              userAns: userAnswerList,
                            ),
                          ),
                        );
                      }
                      toNextPage();
                    }
                  },
                  controller: answerController,
                  question: questions[index],
                ),
              ),
            ),
            Text(
              '${currentIndex + 1}/${questions.length}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class QuizWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String question;
  final TextEditingController controller;
  const QuizWidget({
    super.key,
    required this.onTap,
    required this.question,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          Text(
            '$question ?',
            style: const TextStyle(
              fontSize: 45,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value == '') {
                return 'Your answer is empty please fill up';
              }
              return null;
            },
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              hintText: 'Enter your answer',
              hintStyle: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: ElevatedButton(
              onPressed: onTap,
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
              ),
            ),
          )
        ],
      ),
    );
  }
}
