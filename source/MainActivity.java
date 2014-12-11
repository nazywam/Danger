package ;

import android.os.Bundle;
import android.view.WindowManager;

public class MainActivity extends org.haxe.nme.GameActivity {
        
         protected void onCreate(Bundle state) {
                super.onCreate(state);
                getWindow().addFlags( WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
         }
}