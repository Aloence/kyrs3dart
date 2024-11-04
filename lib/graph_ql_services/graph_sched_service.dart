import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';
import 'package:schedule_app/graph_ql_services/graphql_config.dart';


class ScheduleGraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  
  Future<List<ScheduleModel>> getSchedules() async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           query Query() {
              getSchedules() {
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
            """),
        ),
      );

      if (result.hasException) {
        print('dkooo');
        throw Exception(result.exception);
      } else {
        print('dadada');
        List? res = result.data?['getSchedules'];

        if (res == null || res.isEmpty) {
          return [];
        }
        List<ScheduleModel>  schedules=
            res.map((schedule) => ScheduleModel.fromMap(map: schedule)).toList();
        // schedules.map((schedule)=>print(schedule));
        print(schedules);
        return schedules;
      }
    } catch (error) {
      return [];
    }
  }
  // getOneStop()-> List[buses]
   Future<ScheduleModel> getScheduleById({
    required int id,
  }) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              query Query(\$scheduleId: Int!) {
                getScheduleById(scheduleId: \$scheduleId){
                
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
            """),
          variables: {
            "scheduleId":id,
          },
        ),
      );

      if (result.hasException) {
        print('oo[]');
        throw Exception(result.exception);
      } else {
        // print(result.data);
        Map res = result.data?['getScheduleById'];
        // if (res == null || res.isEmpty) {
        //   return null;
        // }
        print(res);
        ScheduleModel schedule = ScheduleModel.fromMap(map: res);
        return schedule;
      }
    } catch (error) {
      // #kost
      print("mda");
      print(error);
      rethrow;
      // return null;
    }
  }

  Future<bool> createSchedule({
    required ScheduleInput scheduleInput,
  }) async {
    try {
      print(scheduleInput);
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              mutation Mutation(\$scheduleInput: ScheduleInput!) {
                createSchedule(scheduleInput: \$scheduleInput){
                  id
                }
              }
            """),
          variables: {
            "scheduleInput": {
              "name":scheduleInput.name,
              "start":scheduleInput.start,
              "end":scheduleInput.end,
              "routeId":scheduleInput.routeId,
              "schedule":scheduleInput.schedule.map((stop) => stop.toJson()).toList(),
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