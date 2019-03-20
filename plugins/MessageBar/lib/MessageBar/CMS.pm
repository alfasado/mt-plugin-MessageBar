package MessageBar::CMS;
use strict;
use warnings;

use MT::Util qw( trim );

sub _hdlr_ts_header {
    my ( $cb, $app, $tmpl ) = @_;
    return 1 if $app->param( 'dialog' );

    my $plugin = MT->component('MessageBar');

    my $message = $plugin->get_config_value( 'messagetext' );
    $message = MT->config->MessageText if MT->config->MessageText;
    ( $message =  $app->base ) =~ s!https?://!! unless $message;
    $message = trim( $message );
    $message = Encode::decode_utf8( $message);

    my $textcolor = $plugin->get_config_value( 'messagetextcolor' );
    $textcolor = MT->config->MessageTextColor if MT->config->MessageTextColor;

    my $backgroundcolor = $plugin->get_config_value( 'messagebackgroundcolor' );
    $backgroundcolor = MT->config->MessageBackgroundColor if MT->config->MessageBackgroundColor;

    return unless ( $message && $textcolor && $backgroundcolor );

    my $use_powercms = MT->component('PowerCMS') ? 1 : 0;

    my $point = quotemeta(q{</head>});
    my $plugin_tmpl = File::Spec->catdir( $plugin->path, 'tmpl', 'insert_header.tmpl' );
    my $insert = qq{<mt:include name="$plugin_tmpl" component="MessageBar" content="$message" color="$textcolor" backgroundcolor="$backgroundcolor" use_powercms="$use_powercms">\n};
    $$tmpl =~ s/($point)/$insert$1/;
}

1;
