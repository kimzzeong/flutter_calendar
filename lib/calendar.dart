import 'package:calendar_flutter/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>{

  Map<DateTime,List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  @override
  void initState(){
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose(){
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ko-KR',null);
    return Scaffold(
      appBar: AppBar(
        title: Text("체크리스트"),
        centerTitle: true,
        backgroundColor: Color(0xFFB28ED9),
      ),
      body: SingleChildScrollView( // 이거 설정 안해주면 리스트가 추가되면서 화면 넘어갈 시 에러
        child: Column(
          children: [
            TableCalendar(
                    focusedDay: selectedDay,
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                    calendarFormat: format,
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekendStyle: TextStyle(
                        color: Colors.red,
                      )
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),

                    daysOfWeekHeight: 30, // 한글로 바꾸니까 글자가 좀 잘려서 높이 줌
                    onFormatChanged: (CalendarFormat _format,){
                      setState((){
                        format = _format;

                      });
                    },
                    locale: 'ko-KR', //한국어로 변경
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,

                    //날짜 바꿨을 때
                   onDaySelected: (DateTime selectDay, DateTime focusDay){
                      setState((){
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                    },
                    selectedDayPredicate: (DateTime date){
                      return isSameDay(selectedDay, date);
                    },

                    eventLoader: _getEventsfromDay,

                    //캘린더 스타일 지정
                    calendarStyle: const CalendarStyle(
                      todayTextStyle: TextStyle(color: Colors.black),
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration( //선택된 날짜 표시
                        color: Color(0xFFB28ED9),
                        shape: BoxShape.circle
                      ),
                      selectedTextStyle: TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration( // 현재 날짜 표시
                        color: Color(0xC7E7E7E7),
                        shape: BoxShape.rectangle,
                      ),
                      defaultDecoration: BoxDecoration(
                          //color: Color(0xFFC0ADD5),
                          shape: BoxShape.rectangle
                      ),
                      weekendDecoration: BoxDecoration(
                        //color: Color(0xC7E7E7E7),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
            ..._getEventsfromDay(selectedDay).map((Event event) => Card(
              child: CheckboxListTile(
                title: Text(event.title),
                //controlAffinity: ListTileControlAffinity.leading, // 체크박스 앞으로
                value: event.ischecked,
                onChanged: (bool? value) {
                  setState((){
                    event.ischecked = value!;
                  });
              },
              )
            ),
    ),
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color(0xFFB28ED9),
          label: Text("추가"),
          icon : Icon(Icons.add),
          onPressed: () =>
              showDialog(
                  context : context,
                  builder: (context) => AlertDialog(
                    title: Text("추가"),
                    content: TextFormField(controller: _eventController,),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("취소")),
                      TextButton(
                          child: Text("확인"),
                          onPressed: () {
                            if (_eventController.text.isEmpty) {
                              //리스트 내용이 없을 때 아무 일도 일어나지 않음
                            } else {
                              setState((){
                                if (selectedEvents[selectedDay] != null) {
                                  selectedEvents[selectedDay]?.add(
                                      Event(title: _eventController.text,ischecked: false)
                                  );
                                } else {
                                  selectedEvents[selectedDay] = [
                                    Event(title: _eventController.text,ischecked: false)
                                  ];
                                }
                              });
                            }
                            _eventController.clear();
                            Navigator.pop(context);
                            return;
                          },
                        ),
                    ],
                  )
              ),
        ),
    );
  }
}
