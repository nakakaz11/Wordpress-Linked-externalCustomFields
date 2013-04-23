<?php


require_once './phplib/medoo.php';
$database = new medoo('_wp3nakak');

require "todo.class.php";

// Select all the todos, ordered by position:
$query = $database->select("wp1_ex_sw_github","*", array(
      "ORDER" => "position"
  )
);
//$query = $database->query("SELECT * FROM wp1_ex_sw_github ORDER BY position ASC");

$todos = array();

foreach ($query as $item) { $todos[] = new ToDo($item); }

?>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="utf-8">
  <title>AJAX-ed SW CalorieToDo(´･_･`) |On Github(2)| SW</title>

<!-- Including the jQuery UI Human Theme -->
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/humanity/jquery-ui.css" type="text/css" media="all">

<!-- Our own stylesheet -->
<link rel="stylesheet" type="text/css" href="styles.css">


<!-- CDN -->
 <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
 <script src="http://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.0/jquery-ui.min.js"></script>
 <script type="text/javascript" src="js/script.js"></script>
  <!--[if IE]>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="-1">
  <![endif]-->
  <!--[if IE 9 ]><![endif]-->
</head>

<body>

<h1 class="new cal"><a href="calorie.html">SW CalorieToDo WPDB |On Github(2)| View ▶</a></h1>
<!--<h2><a href="http://tutorialzine.com/2010/03/ajax-todo-list-jquery-php-mysql-css/">Go Back to the Tutorial &raquo;</a></h2>-->
<div id="main">

  <ul class="todoList">

    <?php
    foreach($todos as $item){ echo $item; }
    ?>

    </ul>

<a id="addButton" class="green-button" href="#">Add 可変長</a>
</div>
<!-- This div is used as the base for the confirmation jQuery UI POPUP. Hidden by CSS. -->
<div id="dialog-confirm" title="Delete Item?">削除しまつか？</div>
<h1 class="new wp"><a href="http://www.samuraiworks.org/blog/">◀ WPDB | SWblog</a></h1>
<p class="note">Add only one in 1 seconds.</p>

<!-- Including our scripts -->

</body>
</html>
