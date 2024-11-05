

// #kost вопросы вообще на рандом стоят
class StopModel {
  final int id;
  final String name;

  StopModel({
    required this.id,
    required this.name,
  });

  static StopModel fromMap({required Map map}) {
    return StopModel(
      id: map['id'],
      name: map['name'],
    );
  }
}

class RouteModel {
  final int id;
  final String? name;
  
  final StopModel start;
  final StopModel end;
  List<StopModel>? stops;

  RouteModel({
    required this.id,
    required this.start,
    required this.end,
    this.name,
    this.stops,
  });
  static RouteModel fromMap({required Map map}) {
    List<StopModel> stopsList = (map['stops'] is List)
        ? (map['stops'] as List)
            .map((stop) => StopModel.fromMap(map: stop))
            .toList()
        : [];

    return RouteModel(
      id: map['id'],
      stops: stopsList,
      name:map['name']?.toString(),
      start:StopModel.fromMap(map: map['start']),
      end:StopModel.fromMap(map: map['end']),
    );
  }
}

class SchedulStopModel {
  final int id;
  final String time;
  final StopModel stop;

  SchedulStopModel({
    required this.id,
    required this.time,
    required this.stop,
  });

  static SchedulStopModel fromMap({required Map map}) {
    return SchedulStopModel(
      id: map['id'],
      time: map['time'],
      stop:StopModel.fromMap(map:map['stop']),
    );
  }
}

class ScheduleModel {
  final String start;
  final String end;
  final String name;
  final int id;

  final RouteModel route;
  final List<SchedulStopModel>? schedule;


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Проверка на идентичность
    if (other is! ScheduleModel) return false; // Проверка на тип
    return id == other.id; // Сравнение по ID
  }
  ScheduleModel({
    required this.start,
    required this.end,
    required this.id,
    required this.route,
    required this.name,
    this.schedule,
  });
  static ScheduleModel fromMap({required Map map}) {
    var scheduleStopsList = (map['schedule'] as List)
        .map((stop) => SchedulStopModel.fromMap(map:stop))
        .toList();
    return ScheduleModel(
      id: map['id'],
      route: RouteModel.fromMap(map:map['route']),
      name:map['name'].toString(),
      start:map['start'].toString(),
      end:map['end'].toString(),
      schedule: scheduleStopsList,
    );
  }
}

class BusModel{
  final int id;
  final String name;
  final double price;
  final ScheduleModel schedule;

  BusModel({required this.id, required this.name, required this.price, required this.schedule});

  static BusModel fromMap({required Map map}) {

    return BusModel(
      id: map['id'],
      name: map['name'].toString(),
      price:map['price'],
      schedule: ScheduleModel.fromMap(map: map['schedule'])
    );
  }
}


class StopInput {
  final String name;

  StopInput({
    required this.name,
  });
}

class RouteInput {
  final String name;
  final List<int> stopIds;

  RouteInput({
    required this.name,
    required this.stopIds,
  });
}

class ScheduleStopInput {
  final String time;
  final int stopId;

  ScheduleStopInput({
    required this.time,
    required this.stopId,
  });

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'stopId': stopId,
    };
  }
}

class ScheduleInput {
  final String name;
  final String start;
  final String end;

  final int routeId;
  final List<ScheduleStopInput> schedule;

  ScheduleInput({
    required this.name,
    required this.start,
    required this.end,
    required this.routeId,
    required this.schedule,
  });
}

class BusInput {
  final String name;
  final double price;
  final int scheduleId;

  BusInput({
    required this.name,
    required this.price,
    required this.scheduleId,
  });
}