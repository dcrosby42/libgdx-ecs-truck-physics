class StatsSystem
  def tick(delta, entity_manager)
    entity_manager.get_all_components_of_type(StatsComponent).each do |sc|
      sc.fps = Gdx.graphics.frames_per_second
      unless sc.expected_framerate.nil? or sc.time_per_loop.nil?
        sc.utilization = (sc.time_per_loop / (1.0 / sc.expected_framerate) * 100).to_i
      end
    end
  end
end
