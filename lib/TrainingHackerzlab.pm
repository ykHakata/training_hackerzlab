package TrainingHackerzlab;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    my $mode    = $self->mode;
    my $moniker = $self->moniker;
    my $home    = $self->home;
    my $common  = $home->child( 'etc', "$moniker.common.conf" )->to_string;
    my $conf    = $home->child( 'etc', "$moniker.$mode.conf" )->to_string;

    # 設定ファイル (読み込む順番に注意)
    $self->plugin( Config => +{ file => $common } );
    $self->plugin( Config => +{ file => $conf } );
    my $config = $self->config;

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer') if $config->{perldoc};

    # コマンドをロードするための他の名前空間
    push @{ $self->commands->namespaces }, 'TrainingHackerzlab::Command';

    # Router
    my $r = $self->routes;

    # トップページ
    $r->get('/')->to('Hackerz#index');
    $r->get('/hackerz')->to('Hackerz#index');

    # 認証関連
    $r->get('/auth/create')->to('Auth#create');
    $r->get('/auth/:id/edit')->to('Auth#edit');
    $r->get('/auth/:id')->to('Auth#show');
    $r->get('/auth')->to('Auth#index');
    $r->post('/auth/login')->to('Auth#login');
    $r->post('/auth/logout')->to('Auth#logout');
    $r->post('/auth/:id/update')->to('Auth#update');
    $r->post('/auth/:id/remove')->to('Auth#remove');
    $r->post('/auth')->to('Auth#store');
}

1;
