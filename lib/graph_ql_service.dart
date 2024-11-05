import 'package:flutter/material.dart';
import 'package:schedule_app/graph_ql_services/graph_bus_service.dart';
import 'package:schedule_app/graph_ql_services/graph_route_service.dart';
import 'package:schedule_app/graph_ql_services/graph_sched_service.dart';
import 'package:schedule_app/graph_ql_services/graph_types.dart';
import 'package:schedule_app/graph_ql_services/graphql_st_service.dart';


class GraphQLService{
  final StopGraphQLService _stopGraphQLService = StopGraphQLService();
  final RouteGraphQLService _routeGraphQLService = RouteGraphQLService();
  final ScheduleGraphQLService _scheduleGraphQLService = ScheduleGraphQLService();
  final BusGraphQLService _busGraphQLService = BusGraphQLService();

  Future<List<StopModel>> getStops() async {
    return _stopGraphQLService.getStops();
  }
  Future<StopModel> getStopById({required int stopId})async {
    return _stopGraphQLService.getStopById(stopId: stopId);
  }
  Future<bool> createStop({required StopInput stopInput}) async{
    return _stopGraphQLService.createStop(stopInput: stopInput);
  }
  Future editStop({
    required int stopId,
    required StopInput stopInput,
  }) async {
    return _stopGraphQLService.editStop(stopId: stopId, stopInput: stopInput);
  }
  Future<List<RouteModel>> getRoutes() async {
    return _routeGraphQLService.getRoutes();
  }
  Future<RouteModel> getRouteById({
    required int routeId,
  }) async {
    return _routeGraphQLService.getRouteById(routeId: routeId);
  }

  Future<bool> createRoute({
    required RouteInput routeInput,
  }) async {
    return _routeGraphQLService.createRoute(routeInput: routeInput);
  }


  Future<List<ScheduleModel>> getSchedules() async {
    return _scheduleGraphQLService.getSchedules();
  }

  Future<ScheduleModel> getScheduleById({
    required int scheduleId,
  }) async {
    return _scheduleGraphQLService.getScheduleById(scheduleId: scheduleId);
  }

  Future<bool> createSchedule({
    required ScheduleInput scheduleInput,
  }) async {
    return _scheduleGraphQLService.createSchedule(scheduleInput: scheduleInput);
  }

  Future<List<BusModel>> getBuses() async {
    return _busGraphQLService.getBuses();
  }

  Future<BusModel> getBusById({
    required int busId,
  }) async {
    return _busGraphQLService.getBusById(busId: busId);
  }
  
  Future<bool> createBus({
    required BusInput busInput,
  }) async {
    return _busGraphQLService.createBus(busInput: busInput);
  }
}