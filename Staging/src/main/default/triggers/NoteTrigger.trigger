trigger NoteTrigger on Note (before update) {
    for(Note  item: Trigger.New)
    {
        item.AddError('Update Note is not allowed');
    }
}