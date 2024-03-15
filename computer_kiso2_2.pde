import http.requests.*;

// 町域情報取得API
String townApiUrl = "https://geoapi.heartrails.com/api/json?method=getTowns&prefecture=%E6%9D%B1%E4%BA%AC%E9%83%BD";

// 不動産取引価格情報取得API
String realEstateApiUrl = "https://www.land.mlit.go.jp/webland/api/TradeListSearch?from=20151&to=20152&area=13";

// プロットした時の画面の高さ
int plotWindowHeight = 500;


void setup() {
    size(1280, 780);
    background(0);
    
    // ----------- 町域情報取得APIを読み込んで各町の座標を決める
    // API呼び出し
    GetRequest get = new GetRequest(townApiUrl);
    get.send(); 
    JSONObject allTownData = parseJSONObject(get.getContent());
    JSONArray allTownDataArray = allTownData.getJSONObject("response").getJSONArray("location");

    // 町のx座標で一番小さい値を探す
    float minTownX = float(allTownDataArray.getJSONObject(0).getString("x"));
    // 町のx座標で一番大きい値を探す
    float maxTownX = float(allTownDataArray.getJSONObject(0).getString("x"));
    // 町のy座標で一番小さい値を探す
    float minTownY = float(allTownDataArray.getJSONObject(0).getString("y"));
    // 町のy座標で一番大きい値を探す
    float maxTownY = float(allTownDataArray.getJSONObject(0).getString("y"));

    for (int i = 0; i < allTownDataArray.size(); i++) {
        float townX = float(allTownDataArray.getJSONObject(i).getString("x"));
        if (minTownX > townX) {
            minTownX = townX;
        }
        if (maxTownX < townX) {
            maxTownX = townX;
        }
        float townY = float(allTownDataArray.getJSONObject(i).getString("y"));
        if (minTownY > townY) {
            minTownY = townY;
        }
        if (maxTownY < townY) {
            maxTownY = townY;
        }
    }

    float plotWindowWidth = (plotWindowHeight * (maxTownX - minTownX)) / (maxTownY - minTownY);

    // 町の座標に点を打つ
    for (int i = 0; i < allTownDataArray.size(); i++) {
        float townX = float(allTownDataArray.getJSONObject(i).getString("x"));
        townX = map(townX, minTownX, maxTownX, width/2 - plotWindowWidth/2, width/2 + plotWindowWidth/2);
        float townY = float(allTownDataArray.getJSONObject(i).getString("y"));
        townY = map(townY, minTownY, maxTownY, height/2 - plotWindowHeight/2, height/2 + plotWindowHeight/2);
        stroke(255);
        ellipse(townX, townY, 2, 2);
    }

    // ----------- 町域情報取得APIを読み込んで各町の座標を決める end

    // ----------- 不動産APIでデータを取る。
    // ----------- 平成27年第一四半期～第二四半期
    // API呼び出し
    GetRequest getRealEstate = new GetRequest(realEstateApiUrl);
    getRealEstate.send(); 
    JSONObject allRealEstateData = parseJSONObject(getRealEstate.getContent());
    // 全データ
    JSONArray allRealEstateDataArray = allRealEstateData.getJSONArray("data");
    //println(allRealEstateDataArray);
    // 市区町村ごとのデータを作成。
    // 市区町村名・x軸・y軸・取引価格平均・面積平均

    // 市区町村ごとにデータをグループ
    // println(allRealEstateDataArray);
    JSONArray MunicipalityArray = new JSONArray();
   // String[] MunicipalityArray;
    for (int i = 0; i < allRealEstateDataArray.size(); i++) {
        // 市区町村名(Municipality)の配列を作る
        if (i != 0) {
        println(MunicipalityArray.getString(i - 1));
        }
        if (i == 0 || MunicipalityArray.getString(i - 1) != allRealEstateDataArray.getJSONObject(i).getString("Municipality")) {
            MunicipalityArray.setString(i, allRealEstateDataArray.getJSONObject(i).getString("Municipality"));
        }
//        MunicipalityArray[1] = allRealEstateDataArray.getJSONObject(i).getString("Municipality");
        // 重複市区町村を削除

    }
   // println(MunicipalityArray);
}

void draw() {
    
}