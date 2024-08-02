FROM elixir

WORKDIR /be-elixir--code-exercise--KevinDaSilvaS

COPY ./ .

EXPOSE 4000

ENV PORT=4000 

CMD mix local.hex --force

#RUN mix setup

#RUN mix local.rebar --force

#CMD mix phx.server