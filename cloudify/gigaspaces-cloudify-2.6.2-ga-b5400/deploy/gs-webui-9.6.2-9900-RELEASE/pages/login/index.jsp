<%@taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>



<layout:loginTemplate>
    <jsp:attribute name="body">
        <div class="background">
            <div class="column">
                <div class="content">
                    <div class="sprite logo">

                    </div>

                    <div class="sprite form-background">
                        <div class="form-area">
                            <div class="login-error-message">
                                Authentication failed: username or password incorrect, please try again
                            </div>
                            <form class="complex-form" action="/login/submit.do" method="POST">
                                <div class="form-content">
                                    <div class="display-table expand">
                                        <div class="display-cell login-welcome">
                                            <div class="msg-welcome">Welcome</div>
                                            <div class="msg-login">Please Log in</div>
                                        </div>
                                        <div class="intro align-bottom display-cell">
                                            <div>
                                                You may enter a locator or a group name to <br/>change the default cluster discovery
                                                policy
                                            </div>
                                        </div>
                                    </div>
                                    <div class="display-table expand input-area">
                                        <div class="display-cell login-input">
                                            <div class="input-section">
                                                <div class="label">Username</div>
                                                <input type="text" name="username"/>
                                            </div>
                                            <div class="input-section">
                                                <div class="label">Password</div>
                                                <input type="password" name="password"/>
                                            </div>
                                        </div>
                                        <div class="display-cell admin-input">
                                            <div class="input-section">
                                                <div class="label">Groups</div>
                                                <input type="text" name="groups" placeholder="(optional)"/>
                                            </div>
                                            <div class="input-section">
                                                <div class="label">Locators</div>
                                                <input type="text" name="locators" placeholder="(optional)"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="buttons">
                                        <input type="submit" value="login" class="sprite login-btn btn"/>
                                    </div>
                                </div>

                            </form>

                            <form class="simple-form" action="/login/submit.do" method="POST">
                                <div class="form-content display-table expand">
                                    <div class="display-row">
                                        <div class="display-cell login-welcome">
                                            <div class="msg-welcome">Welcome</div>
                                            <div class="msg-login">Please Log in</div>
                                        </div>
                                        <div class="display-cell login-input">
                                            <div class="input-section">
                                                <div class="label">Username</div>
                                                <input type="text" name="username"/>
                                            </div>
                                            <div class="input-section">
                                                <div class="label">Password</div>
                                                <input type="password" name="password"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="buttons">
                                    <input type="submit" value="login" class="sprite login-btn btn"/>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(function(){
                var loginSuccessful = false;

                $("form").submit(function(e){
                    var $form = $(this);
                    if ( loginSuccessful ){
                        return;
                    }
                    $("body").removeClass("login-error");
                    var $username = $(this).find("input[name=username]");
                    var $password = $(this).find("input[name=password]");

                    var result = $.ajax({
                        async:false,
                        type:'POST',
                        url:'/gs_webui/j_spring_security_check',
                        data: {j_username:$username.val(), j_password:$password.val() },
                        success:function(){
                        },
                        error:function(result){
                            $("body").addClass("login-error");
                            return false;
                        }
                    });

                    if ( Math.floor(result.status / 100 ) == 2){
                        return true;
                    }else{
                        console.log(["stopping propogation"]);
                        e.stopPropagation();
                        return false;
                    }
                });

            })
        </script>
    </jsp:attribute>
</layout:loginTemplate>