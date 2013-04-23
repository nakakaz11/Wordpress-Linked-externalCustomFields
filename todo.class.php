<?php
require_once './phplib/medoo.php';
$database = new medoo('_wp3nakak');

class ToDo
{
  /* TODO項目データを格納する配列: */
  private $data;

  /* The constructor */
  public function __construct($par)
  {
    if (is_array($par))
      $this->data = $par;
  }

  /* これは、自動的に呼び出され、インビルド"マジック"メソッドです
    PHPによって我々はエコー持つToDoオブジェクトを出力するとき。*/
  public function __toString()
  {
    // sw add
    $isWppost = "[wpid:" . $this->data['post_id'] . "]"; // WPidぶっこみ
    if ($isWppost == "[wpid:0]") {
      $isWppost = "[fromDB]";
    }
    // 私たちが返す文字列はecho文で出力する
    return '
      <li id="todo-' . $this->data['id'] . '" class="todo">
        <span>' . $isWppost . ' </span><div class="text">' . $this->data['text'] . '</div>
        <span> is </span><div class="misc">' . $this->data['misc'] . '</div><span> kCal.</span>
        <div class="actions">
          <a href="#" class="edit">Edit</a>
          <a href="#" class="delete">Delete</a>
        </div>
      </li>';
  }

  //post_id
  /* 次の図は、静的メソッドです。これらは、ご利用いただけます
     直接、オブジェクトを作成する必要はありません。
     編集方法は、ToDoの項目IDと新しいテキストを受け取り、
     Todoの。データベースを更新する。 */
  public static function edit($id, $text, $misc)
  {
    //$text = self::esc($text);
    //$misc = self::esc($misc);
    if (!$text && !$misc) throw new Exception("Wrong update text! misc!"); //例外投げる

    // misc 追加
    /*mysql_query("UPDATE wp1_ex_sw_github
    SET text='".$text."', misc='".$misc."'
    WHERE id=".$id);*/

    // sw fix Medoo
    global $database;
    $database->update("wp1_ex_sw_github", array(
      'text' => $text,
      'misc' => $misc
    ), array(
      'id' => $id
    ));


    /*if(mysql_affected_rows($GLOBALS['link'])!=1)
      throw new Exception("Couldn't update item!");*/
  }

  /* deleteメソッド。ToDo項目のIDを取得と、データベースから削除されます。*/
  public static function delete($id)
  {
    // sw fix Medoo
    global $database;
    $database->delete("wp1_ex_sw_github", array(
      'id' => $id
    ));
    /*if(mysql_affected_rows($GLOBALS['link'])!=1)
      throw new Exception("Couldn't delete item!");*/
  }

  /* order時に並べ替えるメソッドが呼び出されます taskが変更されます。
  配列パラメータをとり、その新しい順番に仕事のIDが含まれています。*/
  public static function rearrange($key_value)
  {
    $updateVals = array();
    foreach ($key_value as $k => $v) {
      $strVals[] = 'WHEN ' . (int)$v . ' THEN ' . ((int)$k + 1) . PHP_EOL;
    }
    if (!$strVals) throw new Exception("No data!"); //例外投げる

    // sw fix Medoo
    global $database;
    $database->query(
      "UPDATE wp1_ex_sw_github SET position = CASE id " . join("", $strVals) . " ELSE position END"
    );

    /*if(mysql_error($GLOBALS['link']))
    throw new Exception("Error updating positions!");*/

  }

  /* CreateNewメソッドは、TODOのテキストだけを取りdatabseへの書き込みやAJAXフロントエンドに新しいtodoのbackを出力します。*/

  public static function createNew($text, $misc)
  {

    //$text = self::esc($text);
    //$misc = self::esc($misc); // 特殊文字のエスケープ
    if (!$text && !$misc) throw new Exception("Wrong input data!"); //例外投げる

    // sw fix Medoo
    global $database;
    $posMax = $database->max("wp1_ex_sw_github", "position"); // pos最大値

    /*$posResult = $database->query(
      "SELECT MAX(position) FROM wp1_ex_sw_github"
    ) +1 ;*/

    //if(mysql_num_rows($posResult))
    //  list($position) = mysql_fetch_array($posResult);

    //if (!$position) $position = 1;

    /*if ($posResult = $database->count("wp1_ex_sw_github", "position")) {
      list($position) = $database->get("wp1_ex_sw_github", "*",
        array(
          "position" => $posResult
        ));
    }*/

    $database->insert("wp1_ex_sw_github",
      array(
        "text"     => $text,
        "misc"     => $misc,
        "position" => $posMax + 1
      )
    );

    /*if(mysql_affected_rows($GLOBALS['link'])!=1)
      throw new Exception("Error inserting!");*/

    // 新規ToDoを作成し、それを直接出力する
    echo (new ToDo(array(
      'id' => $database->max("wp1_ex_sw_github", "id"),
      //'id'   => mysql_insert_id($GLOBALS['link']),
      'text' => $text,
      'misc' => $misc // misc 追加
    )));

    exit;
  }

  /* A helper method to sanitize a string:  */
  /*public static function esc($str){
    if(ini_get('magic_quotes_gpc'))
      $str = stripslashes($str);
    return mysql_real_escape_string(strip_tags($str,'<a>'));  // aタグだけ許可
  }*/

} // closing the class definition

?>