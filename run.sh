#!/bin/bash

# Check if the folder exists
if [ -d results ]; then
    # Folder exists, so empty its contents
    rm -r results/*
else
    # Folder does not exist, so create it
    mkdir -p results
fi

docker rmi dqn_zoo:latest || true

docker build -t dqn_zoo:latest .

agent=skeleton
ATARI_GAMES=(alien amidar assault asterix asteroids atlantis bank_heist battle_zone beam_rider berzerk bowling boxing breakout centipede chopper_command crazy_climber defender demon_attack double_dunk enduro fishing_derby freeway frostbite gopher gravitar hero ice_hockey jamesbond kangaroo krull kung_fu_master montezuma_revenge ms_pacman name_this_game phoenix pitfall pong private_eye qbert riverraid road_runner robotank seaquest skiing solaris space_invaders star_gunner surround tennis time_pilot tutankham up_n_down venture video_pinball wizard_of_wor yars_revenge zaxxon)

for game in "${ATARI_GAMES[@]}"; do
  for seed in {1..5}; do
    docker rm "dqn_zoo_${agent}" || true
    docker run -v results:/tmp/results --gpus all --name "dqn_zoo_${agent}" dqn_zoo:latest \
        -m "dqn_zoo.${agent}.run_atari" \
        --environment_name="${game}" \
        --seed="${seed}" \
        --results_csv_path="/tmp/results/${agent}/${game}/${seed}/results.csv"
  done
done
