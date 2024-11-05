import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';
import 'package:schedule_app/graph_ql_services/graphql_config.dart';



class BusGraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  
  Future<List<BusModel>> getBuses() async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           query Query() {
              getBuses{
                id
                name
                price
                schedule{
                  id
                  start
                  end
                  name
                  route{
                    id
                    start{
                      id
                      name
                    }
                    end{
                      id
                      name
                    }
                  }
                  schedule{
                    id
                    time
                    stop{
                    id
                    name
                    }
                  }
                }
              }
            }
            """),
        ),
      );

      if (result.hasException) {
        print('resException');
        throw Exception(result.exception);
      } else {
        // print('dadada');
        List? res = result.data?['getBuses'];

        if (res == null || res.isEmpty) {
          return [];
        }
        List<BusModel>  buses=
            res.map((bus) => BusModel.fromMap(map: bus)).toList();
        // buses.map((schedule)=>print(schedule));
        print(buses);
        return buses;
      }
    } catch (error) {
      return [];
    }
  }
  
  Future<BusModel> getBusById({
    required int busId,
  }) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              query Query(\$busId: Int!) {
                getBusById(busId: \$busId){
                  id
                  name
                  price
                  schedule{
                    id
                    start
                    end
                    name
                    route{
                      id
                      name
                      start{
                        id
                        name
                      }
                      end{
                        id
                        name
                      }
                    }
                    schedule{
                      id
                      time
                      stop{
                        id
                        name
                      }
                    }
                  }
                }
              }
            """),
          variables: {
            "busId":busId,
          },
        ),
      );

      if (result.hasException) {
        print('oo[]');
        throw Exception(result.exception);
      } else {
        print(result.data);
        Map res = result.data?['getBusById'];
        // if (res == null || res.isEmpty) {
        //   return null;
        // }
        print(res);
        BusModel route = BusModel.fromMap(map: res);
        // routes.map((route)=>print(route));
        return route;
      }
    } catch (error) {
      // #kost
      print("mda");
      print(error);
      rethrow;
      // return null;
    }
  }

 Future<bool> createBus({
    required BusInput busInput,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              mutation Mutation(\$busInput: BusInput!) {
                createBus(busInput: \$busInput){
                  id
                }
              }
            """),
          variables: {
            "busInput": {
              "name":busInput.name,
              "price":busInput.price,
              "scheduleId":busInput.scheduleId,
            }
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (error) {
      print('rfa');
      print(error);
      return false;
    }
  }


}