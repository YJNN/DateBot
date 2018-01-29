<?php
// parameters
$hubVerifyToken = 'TOKEN123ABDDD';
$accessToken = "EAAXRnZACdlHYBAGoYXFn1ZA6GDdML1j9BVIiAPsxNnaMxkj9zUtlt6I1o3VGOxSSdsuW4fTh9Mr2aZCu7wmJs0yGmXdPWCQ3HeLKldFfHZBMzP8ZBjNVcx8ywwTD7Di0rhG2cSpGxZCpKypMpL2Fa7XcujbOYSmqY54CrXOmfYWAZDZD";

// check token at setup
if ($_REQUEST['hub_verify_token'] === $hubVerifyToken) {
  echo $_REQUEST['hub_challenge'];
  exit;
}

// handle bot's anwser
$input = json_decode(file_get_contents('php://input'), true);

$senderId = $input['entry'][0]['messaging'][0]['sender']['id'];
$messageText = $input['entry'][0]['messaging'][0]['message']['text'];



/*
$answer = "I don't understand. Ask me 'hi'.";
if($messageText == "hi") {
    $answer = "Hello";
}

*/

    $answer="지금부터 시작해보자";

    
    //Connect to the database
    $host = "127.0.0.1";
    $user = "soulla";                     //Your Cloud 9 username
    $pass = "";                                  //Remember, there is NO password by default!
    $db = "date_bot";                                  //Your database name you want to connect to
    $port = 3306;                                //The port #. It is always 3306
    
   
    $connection = mysqli_connect($host, $user, $pass, $db, $port)or die(mysql_error());
    $connection1 = mysqli_connect($host, $user, $pass, $db, $port)or die(mysql_error());
    $connection2 = mysqli_connect($host, $user, $pass, $db, $port)or die(mysql_error());
    $connection3 = mysqli_connect($host, $user, $pass, $db, $port)or die(mysql_error());


$answer="hi, I'm datebot!
I can give you an information about station_issue, station_delay, movie_db. 
If you want a station_issue, please ask me 'station name'.
If you want a station_delay, please ask me 'station name:station name'.
If you want a movie list, please ask me 'movie~number~number'.";

     static $time=0;
     static $time_s=0;
    
     static $count=0;
     static $count_re=0;
     static $s_count=0; 
     static $e_count=0;  
  
     static $count_m=0; 
     static $ms_count=0;
     static $me_count=0; 
     static $count_mre=0; 
    
     static $i=0;
    
     static $stack=array();
     static $stack1=array();
     
    list($start_s, $end_s)=explode(":", $messageText); //시간계산하기위한 시작 역 : 끝 역 (구분)
    list($movie,$s_order, $e_order)=explode("~", $messageText); //영화 이름 순위 //로 구분
   
   
     $query1 ="SELECT * FROM  station_delay"; //시간
     $query2 ="SELECT * FROM station_issue WHERE station_N='$messageText'"; //역 이슈
     $query3 ="SELECT * FROM  movie_db"; //영화
    
    //--------------------------------------------------------------
     
        $result1 = mysqli_query($connection1, $query1);
        $result_1 = mysqli_query($connection1, $query1);
        $result_1_2 = mysqli_query($connection1, $query1);
  
      
        $result2 = mysqli_query($connection2, $query2);
        $result_2 = mysqli_query($connection2, $query2);
 
        $result3 = mysqli_query($connection3, $query3);
        $result_3 = mysqli_query($connection3, $query3);

if($end_s){
      while($row=mysqli_fetch_row($result_1)) {
         $count=$count+1;
          if($row[1]==$start_s)
          {
              $s_count=$count;
          }
          if($row[1]==$end_s)
          {
              $e_count=$count;
          }
      }
      while($row1=mysqli_fetch_row($result_1_2)) {
      
         $count_re=$count_re+1;
       if($count_re>=$s_count && $count_re<=$e_count)
       {
              $time = $time+$row1[2];
       }
      }
    $answer=$time." delay time";
}
        


//영화 순위 보여주기
if($e_order){
      
      while($row3=mysqli_fetch_row($result3)) {
         $count_m=$count_m+1;
          if($row3[0]==$s_order)
          {
              $ms_count=$count_m;
          }
          if($row3[0]==$e_order)
          {
              $me_count=$count_m;
          }
      }
     
      
      while($row4=mysqli_fetch_row($result_3)) {
      
         $count_mre=$count_mre+1;
       if($count_mre>=$ms_count && $count_mre<=$me_count)
       {
            
       $an[$i]=$row4[0].' '.$row4[1].' '.$row4[2].' '. $row4[3].' '.$row4[4].' '.$row4[5].' '.$row4[6];
       array_push($stack, $an[$i]);
        //$stack=array($row1[0], $row1[1], $row1[2], $row1[3], $row1[4], $row1[5], $row1[6]);
         
         $i=$i+1;
       $answer=implode(",",$stack);  
       //  $answer=$an[0].'        \n'.$an[1].'';
       
           
       }
      }
      
      //$answer=$ms_count;
  //  $answer=$stack;
    
}/
        
//역이슈 보여주기
if(mysqli_fetch_row($result2)){
    while ($row2 = mysqli_fetch_row($result_2)) {
  $answer=$row2[2].'  '.$row2[3].'  '.$row2[4].'  '.$row2[5].'  '.$row2[6].'  '.$row2[7].'  '.$row2[8].'  '.$row2[9].' '.$row2[10];
   }
}

$response = [
    'recipient' => [ 'id' => $senderId ],
    'message' => [ 'text' => $answer ]
];
$ch = curl_init('https://graph.facebook.com/v2.6/me/messages?access_token='.$accessToken);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($response));
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
curl_exec($ch);
curl_close($ch);

//based on http://stackoverflow.com/questions/36803518

?>
