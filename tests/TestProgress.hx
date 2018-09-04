import tink.state.*;

import tink.state.Progress;

using tink.CoreApi;

@:asserts
class TestProgress {
  public function new() {}
  
  public function testProgress() {
    var state = Progress.trigger();
    var progress = state.asProgress();
    
    var p = 0.;
    progress.bind({direct: true}, function(v) p = v.a);
    state.progress(0.5, None);
    asserts.assert(p == 0.5);
    state.finish('Done');
    progress.result().handle(function(v) {
      asserts.assert(v == 'Done');
      asserts.done();
    });
    
    return asserts;
  }
  
  public function testFutureProgress() {
    var state = Progress.trigger();
    var progress:Progress<String> = Future.sync(state.asProgress());
    
    var p = 0.;
    progress.bind({direct: true}, function(v) p = v.a);
    state.progress(0.5, None);
    asserts.assert(p == 0.5);
    state.finish('Done');
    progress.result().handle(function(v) {
      asserts.assert(v == 'Done');
      asserts.done();
    });
    
    return asserts;
  }
  
  public function testPromiseProgress() {
    var state:ProgressTrigger<String> = Progress.trigger();
    var progress:Progress<Outcome<String, Error>> = Promise.lift(state.asProgress());
    
    var p = 0.;
    progress.bind({direct: true}, function(v) p = v.a);
    state.progress(0.5, None);
    asserts.assert(p == 0.5);
    state.finish('Done');
    progress.result().handle(function(v) {
      asserts.assert(v.match(Success('Done')));
      asserts.done();
    });
    
    return asserts;
  }
}