FIELDS = ['cmd', 'command', 'start', 'end', 'delta', 'msg', 'stdout', 'stderr']
class CallbackModule(object):
    def playbook_on_play_start(self, pattern):
        print """\
                             _             
                            | |            
 _ __   _____      __  _ __ | | __ _ _   _ 
| '_ \ / _ \ \ /\ / / | '_ \| |/ _` | | | |
| | | |  __/\ V  V /  | |_) | | (_| | |_| |
|_| |_|\___| \_/\_/   | .__/|_|\__,_|\__, |
                      | |             __/ |
                      |_|            |___/ 

"""
        pass
