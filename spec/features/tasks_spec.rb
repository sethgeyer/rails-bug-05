require 'rails_helper'
require 'capybara/rails'

feature 'Tasks' do

  scenario 'User can view tasks' do
    user = create_user email: "user@example.com"
    TaskList.create!(name: "Work List")

    login(user)
    expect(page).to have_content("Nothing here to see!")
    click_on "+ Add Task", match: :first
    fill_in "Description", with: "Something important"
    click_on "Create Task"

    expect(page).to have_content("Something important")
    expect(page).to have_content("Task was created successfully!")
    expect(page).to have_no_content("Nothing here to see!")
  end

  scenario 'User can edit tasks' do
    user = create_user email: "user@example.com"
    task_list = create_task_list(name: "Work List")
    task = create_task(task_list: task_list, description: "Some task", due_date: 2.days.from_now)

    login(user)
    click_on "edit"
    fill_in "Description", with: "Updated task"
    click_on "Update Task"

    expect(page).to have_no_content("Some task")
    expect(page).to have_content("Updated task")
    expect(task.reload).to eq(task)

    click_on "+ Add Task", match: :first
    fill_in "Description", with: "AAAAThe Other Task"
    click_on "Create Task"


    first('.task').click_link('edit')
    fill_in "Description", with: "BBBBThe Other Task"
    click_on "Update Task"
    expect(page).to have_content("Updated task")
    expect(page).to have_content("BBBBThe Other Task")

  end

end