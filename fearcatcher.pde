import io.socket.emitter.*;
import io.socket.client.*;

volatile int anger;
volatile int contempt;
volatile int disgust;
volatile int fear;
volatile int happiness;
volatile int neutral;
volatile int sadness;
volatile int surprise;

Socket socket;

void initFearCatcher() {
  try {
    socket = IO.socket(fearcatcher_osoite);
    socket.on("face:analyzed", new Emitter.Listener() {
      @Override
      public void call(Object... incoming) {
        org.json.JSONObject obj = (org.json.JSONObject)incoming[0];
        try {
          anger = (int)(255.0 * obj.getDouble("anger"));
          contempt = (int)(255.0 * obj.getDouble("contempt"));
          disgust = (int)(255.0 * obj.getDouble("disgust"));
          fear = (int)(255.0 * obj.getDouble("fear"));
          happiness = (int)(255.0 * obj.getDouble("happiness"));
          neutral = (int)(255.0 * obj.getDouble("neutral"));
          sadness = (int)(255.0 * obj.getDouble("sadness"));
          surprise = (int)(255.0 * obj.getDouble("surprise"));
        } catch (Exception ex) {
          ex.printStackTrace();
        }
      }
    });
    socket.connect();
  } catch (Exception ex) {
    print("Couldn't initialize FearCatcher: ", ex.getMessage());
  }
}