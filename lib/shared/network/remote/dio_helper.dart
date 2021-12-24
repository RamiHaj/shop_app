import 'package:dio/dio.dart';


class DioHelper
{
   static late Dio dio;

   static init()
   {
     dio = Dio(
       BaseOptions(
         baseUrl: 'https://student.valuxapps.com/api/',
         receiveDataWhenStatusError: true,
       )
     );
   }

   static Future<Response> getdata(
   {
     required String url,
     String? token,
     String lang = 'en',
     Map<String,dynamic>? query,
    })async
   {
     dio.options.headers =
     {
       'Content-Type':'application/json',
       'lang' : lang,
       'Authorization':token??''
     };
     return await dio.get(
       url ,
       queryParameters: query,
     );
   }

   static Future<Response> postdata(
       {required String url,
         Map<String,dynamic>? query,
        String lang = 'en',
        String? token,
        required Map<String,dynamic> data})
   async{
     dio.options.headers =
     {
       'Content-Type':'application/json',
       'lang':lang,
       'Authorization':token??''
     };
     return await dio.post(
         url,
         data: data,
         queryParameters: query
     );
   }

   static Future<Response> putdata(
       {required String url,
         Map<String,dynamic>? query,
         String lang = 'en',
         String? token,
         required Map<String,dynamic> data})
   async{
     dio.options.headers =
     {
       'Content-Type':'application/json',
       'lang':lang,
       'Authorization':token??''
     };
     return await dio.put(
         url,
         data: data,
         queryParameters: query
     );
   }
}