import 'package:flutter/material.dart';
import 'package:heroserviceapp/models/NewsModel.dart';
import 'package:heroserviceapp/services/rest_api.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketScreen extends StatefulWidget {
  MarketScreen({Key key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'ข่าวประกาศล่าสุด',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: FutureBuilder(
              future: CallAPI().getLastNews(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<NewsModel>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('มีข้อผิดพลาด ${snapshot.error.toString()}'),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  List<NewsModel> news = snapshot.data;
                  return _listViewLastNews(news);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'ข่าวประกาศทั้งหมด',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: FutureBuilder(
              future: CallAPI().getAllNews(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<NewsModel>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('มีข้อผิดพลาด ${snapshot.error.toString()}'),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  List<NewsModel> news = snapshot.data;
                  return _listViewAllNews(news);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  // Flutter Advance Day 5 time 3:02:33
  // สร้างชุด ListView สำหรับการแสดงข่าวล่าสุด ทำ Templete ประมาณนั้น
  Widget _listViewLastNews(List<NewsModel> news) {
    return ListView.builder(
        scrollDirection: Axis.horizontal, // **** ตัวทำ ListView แนวนอน
        itemCount: news.length,
        itemBuilder: (context, index) {
          // Load model
          NewsModel newsModel = news[index];
          return Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/newdetail', arguments: {'id': newsModel.id});
              },
              child: Card(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 125.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.topCenter,
                            image: NetworkImage('${newsModel.imageurl}'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              '${newsModel.topic}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${newsModel.detail}',
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  // Flutter Advance Day 6 time 0:11:00
  // สร้างชุด ListView สำหรับการแสดงข่าวทั้งหมด
  Widget _listViewAllNews(List<NewsModel> news) {
    return ListView.builder(
        scrollDirection: Axis.vertical, // **** ตัวทำ ListView แนวนอน
        itemCount: news.length,
        itemBuilder: (context, index) {
          // Load model
          NewsModel newsModel = news[index];
          return ListTile(
            leading: Icon(Icons.pages),
            title: Text(
              newsModel.topic,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              _launchInBrowser(newsModel.linkurl);
            },
          );
        });
  }

  // ฟังชั่นสำหรับการ Launcher Web Screen -> Link web
  Future<void> _launchInBrowser(String urlString) async {
    if (await canLaunch(urlString)) {
      await launch(
        urlString,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key':'header_value'}
      );
    } else {
      throw 'Could not launch $urlString';
    }
  }
}
