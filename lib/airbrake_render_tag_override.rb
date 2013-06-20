module AirbrakeRenderTagOverride
  # Below is a copy of the radiant method render_tag
  # with 1 line addition: Airbrake.notify(e)...
  # It can be found in:
  # radiant-1.0.1/app/models/page_context.rb
  def render_tag(name, attributes = {}, &block)
    binding = @tag_binding_stack.last
    locals = binding ? binding.locals : globals
    set_process_variables(locals.page)
    super
  rescue Exception => e
    raise e if raise_errors?
    @tag_binding_stack.pop unless @tag_binding_stack.last == binding
    Airbrake.notify(e)
    render_error_message(e.message)
  end
end

