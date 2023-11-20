#include <MDNS.h>
#include <WiFiManager.h>
#include <WiFiUdp.h>

WiFiUDP udp;
WiFiManager wifiManager;
MDNS mdns(udp);

const char *serviceName = "_FLUTTER";
const int servicePort = 5555;
const int udpPort = 5001;

void reponse(const char *, MDNSServiceProtocol,
             const char *name, IPAddress ip, unsigned short,
             const char *);

// for testing only
// TODO: delete later
void testMessage(const char* name, IPAddress ip);

void setup() {
  Serial.begin(115200);
  wifiManager.resetSettings();

  bool res = wifiManager.autoConnect();

  if (!res) {
    // TODO: if failed to connect to wifi, give feedback to user
    Serial.println("Failed to connect");

  } else {
    // if  connected to wifi, initialize mDNS

    Serial.println("Connected...");
    IPAddress localIP = WiFi.localIP();

    mdns.begin(WiFi.localIP(), "esp32");
    Serial.println("mDNS started");

    mdns.setServiceFoundCallback(reponse);
  }
}

void loop() {
  Serial.println(WiFi.getHostname());
  // listen for app service
    // Serial.println("Listening for services...");
  // if (!mdns.isDiscoveringService()) {
  // }
    mdns.startDiscoveringService(serviceName,
                                 MDNSServiceUDP,
                                 servicePort);
  mdns.run();

  delay(100);
}

void reponse(const char *, MDNSServiceProtocol,
             const char *name, IPAddress ip, unsigned short,
             const char *) {
   Serial.println(ip);

  // check if IP address is not empty and if service name is correct
   if(ip == IPAddress(0,0,0,0) && name != "FLUTTER" ) return;

 
  // get service IP address
  // read sensor data and send data to app

  testMessage(name, ip);
}

// TODO: delete later
void testMessage(const char* name, IPAddress ip) {

  String msg = "{\"id\": \"testsensor123\",\"status\": \"connected\"}";

  udp.beginPacket(ip, udpPort);
  udp.print(msg);
  udp.endPacket();

  Serial.print("Message sent to: [ Name: ");
  Serial.print(name);
  Serial.print(" , IP Address: ");
  Serial.print(ip.toString());
  Serial.println(" ]");
}

