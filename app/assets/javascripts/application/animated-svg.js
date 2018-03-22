mumuki.load(function () {

  function _classCallCheck(instance, Constructor) {
    if (!(instance instanceof Constructor)) {
      throw new TypeError("Cannot call a class as a function");
    }
  }

  var noop = function noop() {
  };

  var State = function () {
    function State(name, src, duration) {
      _classCallCheck(this, State);
      this.src = src;
      this.name = name;
      this.duration = duration;
      this.callbacks = {
        end: noop,
        start: noop
      };
    }

    State.prototype.on = function on(event, callback) {
      this.callbacks[event] = callback;
      return this;
    };

    State.prototype.onEnd = function onEnd(callback) {
      return this.on('end', callback);
    };

    State.prototype.onEndSwitch = function onEndSwitch(character, stateName) {
      return this.onEnd(function () {
        return character.switch(stateName);
      });
    };

    State.prototype.onStart = function onStart(callback) {
      return this.on('start', callback);
    };

    State.prototype.play = function play(imageDomElement) {
      this.callbacks.start();
      imageDomElement.src = this.src;
      setTimeout(this.callbacks.end.bind(this), this.duration);
    };

    return State;
  }();

  var Character = function () {
    function Character(imageDomElement) {
      _classCallCheck(this, Character);

      this.states = {};
      this.image = imageDomElement;
    }

    Character.prototype.addState = function addState(state) {
      if (!this.currentState) this.currentState = state;
      this.states[state.name] = state;
      return this;
    };

    Character.prototype.switch = function _switch(stateName) {
      this.currentState = this.states[stateName];
      this.play();
    };

    Character.prototype.play = function play() {
      this.currentState.play(this.image);
    };

    return Character;
  }();

  mumuki.State = State;
  mumuki.Character = Character;

});
