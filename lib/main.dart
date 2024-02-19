import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'components/chat_response_block.dart';
import 'constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Iroh.AI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController textEditingController;
  List<String> messages = [];

  Future<void> sendRequest({required String prompt}) async {
    try {
      setState(() {
        messages.add("Consulting with the spirits");
      });
      var response = await http.post(
        Uri.parse(API_LINK),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $API_KEY",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content":
                  "Please give advice centered around the following prompt as if you are Uncle Iroh from Avatar the Last AirBender. Avoid using advanced vocabulary that wouldn't be found in a kid's show, being overly verbose in your responses, as well as breaking character. Please give a response in a narrative, conversational format that emphasizes character development over absolutes, while still providing actionable advice. Please keep responses around 3 sentences and, when appropriate, have a question at the end of the prompt to dive deeper into the problem the user is facing. Here is the prompt:$prompt"
            }
          ],
          "temperature": 0.7,
          //"max_tokens": 100,
        }),
      );
      var decodedResponse = jsonDecode(response.body);
      setState(() {
        messages.removeLast();
        messages.add(decodedResponse['choices'][0]['message']['content']);
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/background_paper.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(widget.title),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Text(
                          "Iroh.AI",
                          style: TextStyle(
                            color: Colors.deepPurple.shade100,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          if (messages[index]
                              .contains("Consulting with the spirits")) {
                            return Row(
                              children: [
                                Text(
                                  messages[index],
                                  style: GoogleFonts.permanentMarker(),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                LoadingAnimationWidget.threeArchedCircle(
                                    color: Colors.black, size: 20.0)
                              ],
                            );
                          }
                          return ChatResponseBlock(
                            inputText: messages[index],
                            isResponse: index % 2 == 1,
                          );
                        }),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple.shade500),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          setState(() {
                            messages.add(textEditingController.text);
                          });
                          await sendRequest(
                              prompt: textEditingController.text!);
                          textEditingController.clear();
                        },
                      ),
                    ),
                    IconButton(
                      color: Colors.deepPurple,
                      onPressed: () async {
                        setState(() {
                          messages.add(textEditingController.text);
                        });
                        await sendRequest(prompt: textEditingController.text!);
                        textEditingController.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
