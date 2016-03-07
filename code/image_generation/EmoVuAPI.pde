import http.requests.*;

public class EmoVuAPIResult {
  public float joy;
  public boolean tracked;
}

public class EmoVuAPI {
  public EmoVuAPI() {

  } 

  public EmoVuAPIResult processImage(PImage image) {
    println("begin processing images");
    String imageFilename = timestampedFilename("pre_process") + ".jpg";
    image.save(imageFilename);
    String imageFullPath = sketchPath(imageFilename);
    PostRequest post = new PostRequest("https://eyeris-emovu1.p.mashape.com/api/image/");
    post.addHeader("X-Mashape-Key", "JBF2VVemR2mshrnwUsf1xaNmFBxDp1XL6V3jsnFlgtanEIeG6R");
    post.addHeader("LicenseKey", "93126408615820378014745621570452611610139014514450347023845911480730411681");
    post.addFile("imageFile", imageFullPath);
    post.send(); 
    println("response: " + post.getContent());

    EmoVuAPIResult result = new EmoVuAPIResult();

    JSONObject response = parseJSONObject(post.getContent());
    boolean tracked = response.getBoolean("Tracked");
    result.tracked = tracked;
    
    if (tracked) {
      println("found tracked face!");
      JSONArray results = response.getJSONArray("FaceAnalysisResults");
      JSONObject firstResult = results.getJSONObject(0);
      JSONObject emotionResult = firstResult.getJSONObject("EmotionResult");
      float joy = emotionResult.getFloat("Joy");
      println("joy level: " + joy);
      result.joy = joy;
    } else {
      println("face not found");
    }
    
    
    return result;

    //"EmotionResult": {
    //   "Anger": 0.039,
    //   "Computed": true,
    //   "Disgust": 0.006,
    //   "Fear": 0.003,
    //   "Joy": 0.0,
    //   "Neutral": 0.002,
    //   "Sadness": 0.949,
    //   "Surprise": 0.0
    // },
  }

  private String timestampedFilename(String prefix) {
    return prefix + year() + day() + month() + "_" + hour() + "-" + minute() + "-" + second();
  }
}