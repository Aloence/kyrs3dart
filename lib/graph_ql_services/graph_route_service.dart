import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';
import 'package:schedule_app/graph_ql_services/graphql_config.dart';

class RouteGraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<RouteModel>> getRoutes() async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           query Query() {
              getRoutes() {
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
            }
            """),
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {

        List? res = result.data?['getRoutes'];

        if (res == null || res.isEmpty) {
          return [];
        }
        List<RouteModel> routes =
            res.map((route) => RouteModel.fromMap(map: route)).toList();
        // routes.map((route)=>print(route));
        print(routes);
        return routes;
      }
    } catch (error) {
      return [];
    }
  }

  Future<RouteModel> getRouteById({
    required int routeId,
  }) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              query Query(\$routeId: Int!) {
                getRouteById(routeId: \$routeId){
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
                  stops{
                    id
                    name
                  }
                }
              }
            """),
          variables: {
            "routeId":routeId,
          },
        ),
      );

      if (result.hasException) {
        print('oo[]');
        throw Exception(result.exception);
      } else {
        // print(result.data);
        Map res = result.data?['getRouteById'];
        // if (res == null || res.isEmpty) {
        //   return null;
        // }
        print(res);
        RouteModel route = RouteModel.fromMap(map: res);
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

  Future<bool> createRoute({
    required RouteInput routeInput,
  }) async {
    try {
      print(routeInput);
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              mutation Mutation(\$routeInput: RouteInput!) {
                createRoute(routeInput: \$routeInput){
                  id
                }
              }
            """),
          variables: {
            "routeInput": {
              "name":routeInput.name,
              "stopIds":routeInput.stopIds,
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
      return false;
    }
  }

}