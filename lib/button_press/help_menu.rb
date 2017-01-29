class ButtonPress::HelpMenu < ButtonPress
  def process
    help_klass = "HelpMenu::#{@action['name'].classify}".constantize
    puts "Messaging user #{@user['id']} #{help_klass.text}"
    Operationcode::Slack::Im.new(user: @user['id'], text: help_klass.text)
    nil
  end

  private

  def template_path
    Pathname.new(__dir__) + '..' + 'views' + self.class.name.to_s.underscore + '..'
  end

  def class_to_filename
    "#{self.class.name.to_s.demodulize.underscore.downcase}_message.txt.erb"
  end

  def render_button_template
    template = File.read(template_path + class_to_filename)
    ERB.new(template).result(binding)
  end
end