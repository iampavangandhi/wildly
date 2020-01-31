import 'package:animal_welfare_project/pages/animal_single_item_page.dart';
import 'package:animal_welfare_project/utils/size_util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  bool _isLoading = true;
  List animalList = List();
  List ngoList = List();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  List<Widget> _widgetList(List storyList) {
    List<Widget> items = List();
    for (int i = 0; i < 4; i++) {
      items.add(wid(storyList[i]));
    }
    return items;
  }

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            color: Colors.black,
            child: _isLoading
                ? Center(
              child: SpinKitRipple(
                color: Colors.white,
              ),
            )
                : PageView(
              controller: controller,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          CarouselSlider(
                            viewportFraction: 0.9,
                            autoPlay: true,
                            height: 300.0,
                            items: _widgetList(animalList),
                          ),
                          SizedBox(
                            height: 11.0,
                          ),
                          _epicTitle("Our Partners"),
                          _horizontalList(ngoList),
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_up),
                            onPressed: () {
                              controller.animateToPage(1, duration: Duration(milliseconds: 600), curve: Curves.easeOut);
                            },
                          )

                        ],
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 50.0, bottom: 10.0),child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 2.0), itemCount: animalList.length ,itemBuilder: (context, index) => _gridItems(animalList[index])))
                  ],
                )));
  }

  void _initData() async {
    DataSnapshot snapshot =
    await FirebaseDatabase.instance.reference().child('all_animals').once();
    DataSnapshot snapshot1 =
    await FirebaseDatabase.instance.reference().child('ngo_details').once();

    setState(() {
       animalList = (snapshot.value as Map<dynamic, dynamic>).values.toList();
       ngoList = (snapshot1.value as Map<dynamic, dynamic>).values.toList();
      _isLoading = false;
    });
  }

  _gridItems(story) {
      return InkWell(
      onTap: ()  {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnimalSingleItemPage(story['image'], story['name'], story['cause'], true)));
      },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                        height: 200.0,
                        width: 200.0,
                        child: Image.network(
                          story['image'],
                          fit: BoxFit.cover,
                        )),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      width: 200.0,
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
                      top: 0.0,
                      right: 8.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.9),
                        child: Chip(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10.0)),
                            backgroundColor: Colors.white,
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 0.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 3.0),
                            label: Text(
                              story['type'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 11.0),
                            )),
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
                                width: 160.0,
                                child: Text(
                                  '${story['name']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18.0),
                                ),
                              ),
                              Container(
                                width: 160.0,
                                child: Text(
                                  '${descriptionStringShort(story['cause'])}',
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
        ),
      );
    }


  _horizontalList(List storyList) => Container(
    padding: EdgeInsets.all(12.0),
    height: 280.0,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: storyList.length,
        itemBuilder: (context, index) => _listItem(storyList[index])),
  );

  _epicTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 22.0),
    child: Text(title),
  );

  //NGO list
  Widget _listItem(story) {
    return InkWell(
      onTap: ()  {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnimalSingleItemPage(story['image'], story['name'], story['description'], false)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                      height: 250.0,
                      width: 200.0,
                      child: Image.network(
                        story['image'],
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: 200.0,
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
                    top: 0.0,
                    right: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.9),
                      child: Chip(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0)),
                          backgroundColor: Colors.white,
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 0.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 3.0),
                          label: Text(
                            story['manager'],
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 11.0),
                          )),
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
                              width: 160.0,
                              child: Text(
                                '${story['name']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18.0),
                              ),
                            ),
                            Container(
                              width: 160.0,
                              child: Text(
                                '${descriptionStringShort(story['description'])}',
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
      ),
    );
  }

  //the carousel
  Widget wid(story) => InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnimalSingleItemPage(story['image'], story['name'], story['cause'], true)));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  top: 0.0,
                  right: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.9),
                    child: Chip(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10.0)),
                        backgroundColor: Colors.white,
                        labelPadding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 0.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 3.0),
                        label: Text(
                          story['type'],
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 11.0),
                        )),
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
                              '${story['name']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18.0),
                            ),
                          ),
                          Container(
                            width: SizeUtil.width - 96.0,
                            child: Text(
                              '${descriptionStringLong(story['cause'])}',
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
    ),
  );

  descriptionStringShort(String description) => description.length > 22
      ? description.substring(0, 22) + '...'
      : description;

  descriptionStringLong(String description) => description.length > 46
      ? description.substring(0, 46) + '...'
      : description;

}
