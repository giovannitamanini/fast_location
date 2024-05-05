import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fast_location/src/modules/home/components/address_list.dart';
import 'package:fast_location/src/modules/home/components/search_address.dart';
import 'package:fast_location/src/modules/home/components/search_empty.dart';
import 'package:fast_location/src/modules/home/controller/home_controller.dart';
import 'package:fast_location/src/routes/app_router.dart';
import 'package:fast_location/src/shared/colors/app_colors.dart';
import 'package:fast_location/src/shared/components/app_button.dart';
import 'package:fast_location/src/shared/components/app_loading.dart';
import 'package:mobx/mobx.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  TextEditingController searchController = TextEditingController();
  late ReactionDisposer errorReactionDiposer;
  late ReactionDisposer errorRouteReactionDiposer;

  @override
  void initState() {
    super.initState();
    _controller.loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reactsToError();
    reactsToRouteError();
  }

  @override
  void dispose() {
    searchController.dispose();
    errorReactionDiposer(); 
    errorRouteReactionDiposer(); 
    super.dispose();
  }

  void reactsToError() {
    errorReactionDiposer = reaction((_) => _controller.hasError, (
      bool error,
    ) {
      if (error) openDialog("Endereço não localizado");
      _controller.hasError = false;
    });
  }

  void reactsToRouteError() {
    errorRouteReactionDiposer = reaction((_) => _controller.hasRouteError, (
      bool routeError,
    ) {
      if (routeError) {
        openDialog(
          "Busque um endereço para traçar sua rota",
          height: 120,
        );
      }
      _controller.hasRouteError = false;
    });
  }

  void openDialog(String message, {double? height}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: height ?? 100,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,  
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                AppButton(
                  label: "Fechar",
                  action: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return _controller.isLoading
          ? const AppLoading()
          : Scaffold(
              backgroundColor: AppColors.appPageBackground,
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_city,
                                size: 35,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Fast Location",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _controller.hasAddress
                                  ? SearchAddress(
                                      address: _controller.lastAddress!,
                                    )
                                  : const SearchEmpty(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AppButton(
                            label: "Localizar endereço",
                            action: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height: 120,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: searchController,
                                            textAlign: TextAlign.start,
                                            keyboardType:
                                                TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: "Digite o CEP",
                                            ),
                                          ),
                                          AppButton(
                                            label: "Buscar",
                                            action: () {
                                              _controller.getAddress(
                                                searchController.text,
                                              );
                                              Navigator.of(context).pop();
                                              searchController.clear();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              Icon(
                                Icons.place,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Últimos endereços localizados",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          AddressList(
                            addressList: _controller.addressRecentList,
                          ),
                          const SizedBox(height: 20),
                          AppButton(
                            label: "Histórico de endereços",
                            action: () {
                              Navigator.of(context)
                                  .pushNamed(AppRouter.history);
                            },
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: const BottomAppBar(
                shape: CircularNotchedRectangle(),
                child: SizedBox(height: 40),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () => _controller.route(context),
                tooltip: 'Traçar rota',
                child: const Icon(
                  Icons.fork_right,
                  color: Colors.white,
                  size: 45,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            );
    });
  }
}
