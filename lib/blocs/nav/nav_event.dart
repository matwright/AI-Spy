
import 'package:ispy/data/spied_model.dart';

abstract class NavEvent {  }

//home, register, kids,kid_form,device_contacts,contacts

class NavHomeEvent extends NavEvent{
  NavHomeEvent();
}

class NavPlayEvent extends NavEvent{
  NavPlayEvent();
}

class NavGuessEvent extends NavEvent{
  SpiedModel spiedModel;
  NavGuessEvent(this.spiedModel);
}
