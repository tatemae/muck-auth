function apply_add_feed(){jQuery(".add-identity").bind("submit",function(){jQuery("#submit_add_feed").hide();jQuery("#finding_uri_message").show();jQuery(this).ajaxSubmit({dataType:"script",beforeSend:add_headers});return false})}function apply_delete_feed(){jQuery(".identity-feed-delete").bind("submit",function(){jQuery(this).replaceWith(jQuery(jQuery("#muck_ajax_delete_control_message").html()).show());jQuery(this).ajaxSubmit({dataType:"script",beforeSend:add_headers});return false})}
function apply_delete_hover(){jQuery("ul#my-services-list li form").hide();jQuery("ul#my-services-list li").hover(function(){jQuery(this).children("form").show()},function(){jQuery(this).children("form").hide()})}
function apply_show_entry_content(){jQuery(".combined-feed-list .feed-item .feed-title").hover(function(){jQuery(this).next(".combined-feed-list .feed-item .feed-content").show()},function(){jQuery(this).next(".combined-feed-list .feed-item .feed-content").hide()});jQuery(".combined-feed-list .feed-item .feed-content").hover(function(){jQuery(this).show()},function(){jQuery(this).hide()})}
function show_tool(b){jQuery(".tool").hide();jQuery("#content_iframe").width("75%");jQuery("#"+b+"_tool").show();jQuery("#recs_panel").css("left",jQuery("#content_iframe").width()-252);maximize_space();return false}function maximize_space(){var b=jQuery(".tools_container"),a=jQuery("#comments_tools_close_wrapper").height()+5;b.height(jQuery(window).height()-(jQuery("#toolbar").height()+a))}
function setup_entry_comment_submit(){jQuery(".entry-comment-submit").click(function(){jQuery(this).siblings("textarea").hide();jQuery(".entry-comment-submit").hide();jQuery(this).parent().append('<p class="entry-comment-loading"><img src="/images/spinner.gif" alt="loading..." /> '+ADD_COMMENT_MESSAGE+"</p>");var b=jQuery(this).parents("form");jQuery.post(b.attr("action"),b.serialize()+"&format=json",function(a){a=eval("("+a+")");if(a.success){jQuery(".entry-comment-loading").remove();jQuery("#comments_tool").find("textarea").show();
jQuery("#comments_tool").find("textarea").val("");jQuery(".entry-comment-submit").show();jQuery("#comments_container").animate({scrollTop:jQuery("#comments_tool").attr("scrollHeight")},3E3);a=jQuery(a.html);a.hide();jQuery("#comments_wrapper").append(a);a.fadeIn("slow");apply_frame_comment_hover()}else jQuery.jGrowl.info(a.message)});return false})}
function apply_frame_comment_hover(){jQuery(".comment_holder").hover(function(){jQuery(this).addClass("comment-hover")},function(){jQuery(this).removeClass("comment-hover")})}
function setup_share_submit(){jQuery("#share_submit_share_new").click(function(){jQuery(this).parent().append('<p class="share-loading"><img src="/images/spinner.gif" alt="loading..." /> '+ADD_SHARE_MESSAGE+"</p>");jQuery("#share_submit_share_new").hide();var b=jQuery(this).parents("form");jQuery.post(b.attr("action"),b.serialize()+"&format=json",function(a){a=eval("("+a+")");jQuery(".share-loading").remove();jQuery("#share_submit_share_new").show();jQuery.jGrowl.info(a.message)});return false})}
jQuery(document).ready(function(){jQuery("#content_iframe").load(maximize_iframe_height);jQuery(window).bind("resize",function(){maximize_iframe_height()})});function maximize_iframe_height(){jQuery("#content_iframe").height(jQuery(window).height()-jQuery("#toolbar").height());jQuery("#recs_panel").css("left",jQuery("#content_iframe").width()-252)}
function initRecsPanel(){var b=jQuery("#recs_panel");b.append("<div id='rec_close_box' title='Close'>x</div>");jQuery("#rec_close_box").click(function(){jQuery("#recs_panel").hide();jQuery("#show_recommendations_link").show();return false});b.css("left",jQuery("#toolbar").width()-250);b.draggable&&b.draggable()};