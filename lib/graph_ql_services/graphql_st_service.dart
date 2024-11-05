import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:schedule_app/graph_ql_services/graphql_config.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';


class StopGraphQLService{
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<StopModel>> getStops() async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           query Query() {
              getStops() {
                id
                name
              }
            }
            """),
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        List? res = result.data?['getStops'];

        if (res == null || res.isEmpty) {
          return [];
        }

        List<StopModel> stops =
            res.map((stop) => StopModel.fromMap(map: stop)).toList();

        return stops;
      }
    } catch (error) {
      return [];
    }
  }

  Future<StopModel> getStopById({
    required int stopId,
  }) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              query Query(\$stopId: Int!) {
                getStopById(stopId: \$stopId){
                  id
                  name
                }
              }
            """),
          variables: {
            "stopId":stopId,
          },
        ),
      );

      if (result.hasException) {
        // print('oo[]');
        throw Exception(result.exception);
      } else {
        // print(result.data);
        Map res = result.data?['getStopById'];
        // if (res == null || res.isEmpty) {
        //   return null;
        // }
        print(res);
        StopModel stop = StopModel.fromMap(map: res);
        // routes.map((route)=>print(route));
        return stop;
      }
    } catch (error) {
      // #kost
      print("mda");
      print(error);
      rethrow;
      // return null;
    }
  }

  Future<bool> deletestop({required String id}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
            mutation Mutation(\$id: ID!) {
              deleteStop(ID: \$id)
            }
          """),
          variables: {
            "id": id,
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

  Future<bool> createStop({
    required StopInput stopInput,
  }) async {
    try {
      print(stopInput);
      print(stopInput.name);
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              mutation Mutation(\$stopInput: StopInput!) {
                createStop(stopInput: \$stopInput){
                  id
                }
              }
            """),
          variables: {
            "stopInput": {
              "name":stopInput.name,
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

  Future editStop({
    required int stopId,
    required StopInput stopInput,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
              mutation Mutation(\$stopId: Int!, \$stopInput: StopInput!) {
                editStop(stopId: \$stopId, stopInput: \$stopInput){
                  id
                }
              }
            """,
          ),
          variables: {
            "stopId": stopId,
            "stopInput": {
              "name": stopInput.name,
            }
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}