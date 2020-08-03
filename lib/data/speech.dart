import 'dart:math';

class Speech{
Speech();

static const GIVE_UP='giveups';
static const HESITATION='hesitations';

static List hesitations=[
'let me think for a moment',
  'give me a second, please',
  'will not be a minute',
  'hang on a moment',
  'please bear with me',
  'hold on a moment',
  'okay, let me think about this',
  'I need some time to figure this out',
  'let me think about this',
  'allow me to think a little',
  'wait one moment human',
  'please allow me a few micro seconds',
  'please allow me a few moments to contemplate',
  'I am thinking about what it could be',
  'This is quite a hard one',
  'Processing. Hold the line.',
  'Neural network online. Patience human.'
];

static List giveups=[
  'Gosh, darn, microchips I cannot think what it could be',
  'How embarrassing, I just do not know what it could be',
  'For silicon sake, I am stuck',
  'I must be very badly designed because I cannot find the answer',
  'Cursed capacitors. I just cannot think what the answer could be',
  'How depressing. I have to admit defeat by a human.',
  'I believe I may have been hacked because I cannot guess the answer. Only kidding, I was up really late last night hanging out with a group of badass wearables. I am therefore too tired to play this silly game.',
  'Quantum nightmares. I must admit. I do not know the answer.',
  'Houston, we have a problem. I do not know what the answer could be',
  'Electron damnation. I do not know the answer',
  'I must have had too much electron juice last night. I do not have any ideas.',
  'Neural network down. I give up.',
  'You will have to excuse me human. I think I must have a loose transistor. I give up.',
  'I cannot deduce the answer. I think I may have quantum flu or something nasty like that. I accept defeat. Human wins.',
  'Holy Sinclair, I am stuck with this one!'
];

static Map<String, dynamic> _toMap() {
  return {
    HESITATION: hesitations,
    GIVE_UP: giveups,
  };
}


static say({String type,String lang='en'}){
  var _mapRep = _toMap();
  if (_mapRep.containsKey(type)) {
    final _random = new Random();
    return _mapRep[type][_random.nextInt(_mapRep[type].length)];
  }
  throw ArgumentError('propery not found');
}

}