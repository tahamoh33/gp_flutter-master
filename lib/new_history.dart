import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Doctorhistory extends StatefulWidget {
  @override
  DoctorhistoryState createState() => DoctorhistoryState();
}

class DoctorhistoryState extends State<Doctorhistory> {
  int selectedIndex = 0;
  final List<Widget> pages = [
    Doctorhistory(),
  ];

  void NavigateBottom(int index) {
    setState(() {
      selectedIndex = index;
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => pages[selectedIndex])));
    });
  }

  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xf5ffcfd),
          leading: IconButton(
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: ((context) => HeyUser())));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.black,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: NavigateBottom,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(label: ("Home"), icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: ("Predictions"), icon: Icon(Icons.batch_prediction)),
            BottomNavigationBarItem(
                label: ("Profile"), icon: Icon(Icons.person)),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  " Prediction History",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                buildCard(
                    title: 'Glaucoma',
                    description:
                        'a common eye condition where the optic nerve, which connects the eye to the brain',
                    text: 'See more',
                    date: 'Jan09,2020',
                    urlImage:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqa19zXSsi9Pid3Ig6Bun-49bMOB3dCiBwEUfiQ0BGuHGzIHSDB5CceYR1M61Og9wF8q8&usqp=CAU'),
                buildCard(
                    title: 'Cataract',
                    description:
                        'a common eye condition where the optic nerve, which connects the eye',
                    text: 'See more',
                    date: 'Jan09,2020',
                    urlImage:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqa19zXSsi9Pid3Ig6Bun-49bMOB3dCiBwEUfiQ0BGuHGzIHSDB5CceYR1M61Og9wF8q8&usqp=CAU'),
                buildCard(
                    title: 'Amblyopia',
                    description:
                        'a common eye condition where the optic nerve, which connects the eye',
                    text: 'See more',
                    date: 'Jan09,2020',
                    urlImage:
                        'https://www.pinpointeyes.com/wp-content/uploads/2019/04/strabismus_esotropia_large-600x445.png'),
                buildCard(
                    title: 'Retinopathy',
                    description:
                        'a common eye condition where the optic nerve, which connects the eye',
                    text: 'See more',
                    date: 'Jan09,2020',
                    urlImage:
                        'https://www.diabetes.co.uk/wp-content/uploads/2022/11/eyes-open.jpg'),
              ],
            ),
          ],
        ),
      );

  Widget buildCard({
    required String title,
    required String description,
    required String text,
    required String date,
    required String urlImage,
  }) {
    final double radius = 22;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      elevation: 4,
      child: Row(
        children: [
          buildImage(radius, urlImage),
          Expanded(child: buildText(title, description, date)),
        ],
      ),
    );
  }

  Widget buildImage(double radius, String urlImage) => ClipRRect(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(radius),
        ),
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
          width: 112,
          height: 130,
        ),
      );

  Widget buildText(String title, String description, String date) => Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {},
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: ((context) => Results())));
                    },
                    child: const Text('See more',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        )),
                  ),
                ],
              ),
            ),
            Text(
              date,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(width: 10),
            Material(
              type: MaterialType.transparency,
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 4.0),
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    const snackBar =
                        SnackBar(content: Text('True classification'));

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Icon(
                    Icons.done,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Material(
              type: MaterialType.transparency,
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 4.0),
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: InkWell(borderRadius: BorderRadius.circular(5.0),
                    onTap: () {
                  const snackBar =
                      SnackBar(content: Text('wrong classification'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                    child: Icon(
                      Icons.dangerous_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                    r),
              ),
            ),
          ],
        ),
      );
}
