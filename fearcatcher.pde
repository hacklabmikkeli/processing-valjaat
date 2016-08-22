import io.socket.emitter.*;
import io.socket.client.*;

volatile int vihaisuus;
volatile int halveksunta;
volatile int kuvotus;
volatile int pelko;
volatile int onni;
volatile int neutraali;
volatile int surullisuus;
volatile int yllattyneisyys;

Socket socket;

void initFearCatcher() {
  try {
    socket = IO.socket(fearcatcher_osoite);
    socket.on("face:analyzed", new Emitter.Listener() {
      @Override
      public void call(Object... incoming) {
        org.json.JSONObject obj = (org.json.JSONObject)incoming[0];
        try {
          vihaisuus = (int)(255.0 * obj.getDouble("anger"));
          halveksunta = (int)(255.0 * obj.getDouble("contempt"));
          kuvotus = (int)(255.0 * obj.getDouble("disgust"));
          pelko = (int)(255.0 * obj.getDouble("fear"));
          onni = (int)(255.0 * obj.getDouble("happiness"));
          neutraali = (int)(255.0 * obj.getDouble("neutral"));
          surullisuus = (int)(255.0 * obj.getDouble("sadness"));
          yllattyneisyys = (int)(255.0 * obj.getDouble("surprise"));
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