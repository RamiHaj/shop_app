import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/search/searchmodel.dart';
import 'package:shopapp/modules/productsdetails/products_details.dart';
import 'package:shopapp/modules/search/cubit/cubit.dart';
import 'package:shopapp/modules/search/cubit/status.dart';
import 'package:shopapp/shared/constants.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';

class Search_Screen extends StatelessWidget {
  Search_Screen({Key? key}) : super(key: key);

  var keyForm = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          return SafeArea(
            child: Scaffold(
              body: Form(
                key: keyForm,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          validator: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'search must have text';
                            }
                            return null;
                          },
                          onChanged: (text)
                          {
                            if(keyForm.currentState!.validate())
                            {
                              SearchCubit.get(context).getSearch(text: text);
                            }
                          },
                          controller: searchController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                              ),
                              labelText: 'Search',
                              suffixIcon: const Icon(Icons.search)
                          )
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if(state is SearchLoadingStates)
                        const LinearProgressIndicator(color: MainColor,),
                      const SizedBox(
                        height: 20,
                      ),
                      SearchCubit.get(context).searchModel == null
                      ?const Text('')
                      :Expanded(
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context , index) => buildListView(
                                context ,
                                SearchCubit.get(context).searchModel,
                                index,
                                favorites
                            ),
                            separatorBuilder: (context , index) => Padding(
                              padding: const EdgeInsetsDirectional.only(start: 20.0),
                              child: Container(
                                width: double.infinity,
                                height: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            itemCount: SearchCubit.get(context).searchModel!.data.data.length
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget buildListView(context , SearchModel? model , index, Map<int, bool> fav ) =>
      GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Products_Details(
            model!.data.data[index].id
            )));
            },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                  children: [
                 // GestureDetector(child: Image.network(model!.data.data[index].image,height: 250,),),
                  CachedNetworkImage(
                    imageUrl: model!.data.data[index].image,
                    height: 250,
                    placeholder: (context , url) => const Center(child: CircularProgressIndicator(color: MainColor,)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                      model.data.data[index].name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                        height: 10,
                        ),
                  Row(
                    children: [
                      Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                      model.data.data[index].price.toString(),
                      style: const TextStyle(color: MainColor),
                      ),
                      ),
                      const Spacer(),
                      CircleAvatar(
                        backgroundColor: fav[model.data.data[index].id]?? false ? MainColor : Colors.grey[300],
                        child: IconButton(
                          onPressed: () {
                            SearchCubit.get(context).changeFavorites(model.data.data[index].id);
                          },
                          icon: const Icon(Icons.favorite_border_outlined),
                          iconSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                  height: 8,
                  ),
                  ],
            ),
            ),
            ),
          ),
      );
}
