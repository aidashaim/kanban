import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kanban/%20models/card.dart';
import 'package:kanban/%20models/cardItem.dart';
import 'package:kanban/bloc/Provider.dart';
import 'package:kanban/bloc/loginBloc.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text('kanban'.toUpperCase()),
        bottom: TabBar(
          labelStyle: TextStyle(fontSize: 18.0),
          indicatorColor: Theme.of(context).primaryColor,
          controller: _tabController,
          tabs: [
            Tab(text: 'On hold'),
            Tab(text: 'In progress'),
            Tab(text: 'Needs \nreview'),
            Tab(text: 'Approved'),
          ],
        ),
      ),
      body: TabBarView(
        physics: ScrollPhysics(),
        controller: _tabController,
        children: [
          cardsWidget(0),
          cardsWidget(1),
          cardsWidget(2),
          cardsWidget(3),
        ],
      ),
      floatingActionButton: _logoutButton(bloc),
    ));
  }

  Widget cardsWidget(i) {
    return FutureBuilder(
      builder: (context, cardsSnap) {
        switch (cardsSnap.connectionState) {
          case ConnectionState.waiting:
            return Center(child: Text('Loading....'));
          default:
            if (cardsSnap.hasError)
              return Text('Error: ${cardsSnap.error}');
            else
              return ListView.builder(
                itemCount: cardsSnap.data.length,
                itemBuilder: (context, index) {
                  Cards item = cardsSnap.data[index];
                  return CardItem(card: item);
                },
              );
        }
      },
      future: getCards(i),
    );
  }

  Widget _logoutButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.isAuthenticated,
      builder: (context, snapshot) {
        return FloatingActionButton(
            child: Text(
              'Log\nout'.toUpperCase(),
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amber,
            onPressed: bloc.logout);
      },
    );
  }

  Future<List<Cards>> getCards(int i) async {
    Map<String, String> headers = {
      "Authorization": "Basic YXJtYWRhOkZTSDZ6QlowcDl5SA==",
      "Content-Type": "application/json",
    };

    http.Client client = http.Client();
    final response = await client.get(
        'https://trello.backend.tests.nekidaem.ru/api/v1/cards?row=' +i.toString(),
        headers: headers);

    if (response.statusCode == 200) {
      return (json.decode(utf8.decode(response.bodyBytes)) as List)
          .map((i) => Cards.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
