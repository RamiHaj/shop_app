import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/modules/login/shop_login_screen.dart';
import 'package:shopapp/shared/network/local/chache_helper.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoradingModel
{
  final String images;
  final String title;
  final String body;
  BoradingModel(
  {
    required this.images,
    required this.title,
    required this.body,
});
}

class OnBorading extends StatefulWidget {

  @override
  State<OnBorading> createState() => _OnBoradingState();
}

class _OnBoradingState extends State<OnBorading> {
  var BoardController = PageController();

  List<BoradingModel> borading =
  [
    BoradingModel(
      images: 'assets/images/shop.jpg',
      title: 'OnTitle1',
      body: 'OnBorading1'
    ),
    BoradingModel(
        images: 'assets/images/shop1.jpg',
        title: 'OnTitle2',
        body: 'OnBorading2'
    ),
    BoradingModel(
        images: 'assets/images/shop2.jpg',
        title: 'OnTitle3',
        body: 'OnBorading3'
    ),
  ];

  bool islast= false;

  void submit()async
  {
   var value =await Chache_Helper.setData(key: 'onBoarding', value: true);
   if(value)
   {
     Navigator.pushAndRemoveUntil(
         context,
         MaterialPageRoute(builder: (context) => const Shop_Login_Screen()),
             (route) => false);
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: submit,
              child: Text(
                'SKIP',
              )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: BoardController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (int index)
                  {
                    if(index == borading.length -1){
                      setState(() {
                        islast =true;
                      });
                    }else
                      {
                        setState(() {
                          islast = false;
                        });
                      }
                  },
                  itemBuilder: (context , index) => buildboradingitem(borading[index]),
                  itemCount: borading.length,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: BoardController,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: MainColor,
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 5,
                      expansionFactor: 4
                    ),
                    count: borading.length),
                const Spacer(),
                FloatingActionButton(
                    onPressed: ()
                    {
                      if(islast)
                      {
                        submit();
                      }else
                        {
                          BoardController.nextPage(
                              duration: const Duration(
                                  microseconds: 750
                              ),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                    },
                    child : const Icon(Icons.arrow_forward_ios_outlined)
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildboradingitem(BoradingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Expanded(
          child: Image.asset(model.images),
        ),
        Text(
        model.title,
        style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold
        ),
        ),
        const SizedBox(
        height: 15,
        ),
        Text(
        model.body,
        style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold
        ),
        ),
        ],
        );
}
