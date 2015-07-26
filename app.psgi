use Plack::Builder;
use TS::App::Engine::PSGI;

builder {
    TS::App::Engine::PSGI->get_psgi_app();
}
