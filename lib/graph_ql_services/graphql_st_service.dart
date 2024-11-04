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
  // getOneStop()-> List[buses]

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
    required int id,
    required StopInput stopInput,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
              mutation Mutation(\$id: Int!, \$stopInput: StopInput!) {
                editStop(stopId: \$id, stopInput: \$stopInput){
                  id
                }
              }
            """,
          ),
          variables: {
            "id": id,
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

  Future<List<StopModel>> stops({
    int? limit,
    List<String>? ids,
    String? author,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var input = {};
      var filter = {};

      bool shouldApplyLimit = limit != null;
      if (shouldApplyLimit) {
        input.addAll({"limit": limit});
      }

      bool shouldApplyFilter = !(ids == null &&
          author == null &&
          startDate == null &&
          endDate == null);
      if (shouldApplyFilter) {
        bool shouldApplyIDsFilter = ids != null;
        if (shouldApplyIDsFilter) {
          filter.addAll({"ids": ids});
        }

        bool shouldApplyAuthorFilter = author != null;
        if (shouldApplyAuthorFilter) {
          filter.addAll({"author": author});
        }

        bool shouldApplyDateRangeFilter = startDate != null && endDate != null;
        if (shouldApplyDateRangeFilter) {
          filter.addAll({
            "startDate": startDate.toIso8601String(),
            "endDate": endDate.toIso8601String()
          });
        }

        input.addAll({"filter": filter});
      }

      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           query Query(\$input: StopFiltersInput) {
              stops(input: \$input) {
                _id
                author
                title
                year
              }
            }
            """),
          variables: {
            'input': input,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        List? res = result.data?['stops'];

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
}