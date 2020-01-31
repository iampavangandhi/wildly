import 'package:animal_welfare_project/pages/animal_single_item_page.dart';
import 'package:animal_welfare_project/utils/size_util.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {


  List blogList = List();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;

    return _isLoading
        ? Center(
      child: SpinKitRipple(
        color: Colors.white,
      ),
    ) : Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(7),
            itemCount: blogList.length,
            itemBuilder: (BuildContext context, int index) =>
                singleListItem(blogList[index])));
  }

  singleListItem(story) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnimalSingleItemPage(story['image'], story['title'], story['description'], false)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                      height: 300.0,
                      width: SizeUtil.width,
                      child: Image.network(
                        story['image'],
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: SizeUtil.width,
                    height: 60.0,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.black.withOpacity(0.01),
                              ])),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    right: 10.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Container(
                              width: 200,
                              child: Text(
                                '${story['title']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18.0),
                              ),
                            ),
                            Container(
                              width: SizeUtil.width - 96.0,
                              child: Text(
                                '${descriptionStringLong(story['description'])}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  descriptionStringLong(String description) => description.length > 46
      ? description.substring(0, 46) + '...'
      : description;

  void _initData() async {
    DataSnapshot snapshot =
    await FirebaseDatabase.instance.reference().child('blogs').once();

    setState(() {
      blogList = (snapshot.value as Map<dynamic, dynamic>).values.toList();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }
}
