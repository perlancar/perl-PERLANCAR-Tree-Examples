package PERLANCAR::Tree::Examples;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Tree::Create::Callback::ChildrenPerLevel
    qw(create_tree_using_callback);

use Exporter::Rinci qw(import);

our %SPEC;

$SPEC{gen_sample_data} = {
    v => 1.1,
    summary => 'Generate sample tree object',
    args => {
        size => {
            summary => 'Which tree to generate',
            schema => ['str*', in=>['tiny1', 'small1', 'medium1']],
            description => <<'_',

There are several predefined sizes to choose from.

`tiny1` is a very tiny tree, with only depth of 2 and a total of 3 nodes,
including root node.

`small1` is a small tree with depth of 4 and a total of 16 nodes, including root
node.

`medium1` is a tree of depth 7 and ~20k nodes, which is about the size of
`Org::Document` tree generated when parsing my `todo.org` document circa early
2016 (~750kB, ~2900 todo items).

_
            req => 1,
            pos => 0,
            tags => ['data-parameter'],
        },
        backend => {
            schema => ['str*', in=>['array', 'hash', 'insideout']],
            default => 'hash',
            tags => ['data-parameter'],
        },
    },
    result => {
        schema => 'obj*',
    },
    result_naked => 1,
};
sub gen_sample_data {
    my %args = @_;

    my $size = $args{size} or die "Please specify size";
    my $backend = $args{backend} // 'hash';

    my @classes;
    push @classes, "Tree::Example::".ucfirst($backend)."Node";
    push @classes, "Tree::Example::".ucfirst($backend)."Node::Sub$_"
        for 1..7;

    my $nums_per_level;
    my $classes_per_level;
    if ($size eq 'tiny1') {
        $nums_per_level = [2];
        $classes_per_level = [@classes[0..1]];
    } elsif ($size eq 'small1') {
        $nums_per_level = [3, 2, 8, 2];
        $classes_per_level = [@classes[0..4]];
    } elsif ($size eq 'medium1') {
        $nums_per_level = [100, 3000, 5000, 8000, 3000, 1000, 300];
        $classes_per_level = [@classes[0..7]];
    } else {
        die "Unknown size '$size'";
    }

    my $id = 0;
    create_tree_using_callback(
        sub {
            my ($parent, $level, $seniority) = @_;
            $id++;
            my $class = $classes_per_level->[$level];
            my $obj = $class->new;
            $obj->id($id);
            $obj->level($level);
            $obj;
        },
        $nums_per_level,
    );
}

package # hide from PAUSE
    Tree::Example::HashNode;
use parent qw(Tree::Object::Hash);

sub id    { $_[0]{id}    = $_[1] if @_>1; $_[0]{id}    }
sub level { $_[0]{level} = $_[1] if @_>1; $_[0]{level} }

package # hide from PAUSE
    Tree::Example::HashNode::Sub1;
use base qw(Tree::Example::HashNode);

package # hide from PAUSE
    Tree::Example::HashNode::Sub2;
use base qw(Tree::Example::HashNode);

package # hide from PAUSE
    Tree::Example::HashNode::Sub3;
use base qw(Tree::Example::HashNode);

package # hide from PAUSE
    Tree::Example::HashNode::Sub4;
use base qw(Tree::Example::HashNode);

package # hide from PAUSE
    Tree::Example::HashNode::Sub5;
use base qw(Tree::Example::HashNode);

package # hide from PAUSE
    Tree::Example::HashNode::Sub6;
use base qw(Tree::Example::HashNode);

package # hide from PAUSE
    Tree::Example::HashNode::Sub7;
use base qw(Tree::Example::HashNode);


package # hide from PAUSE
    Tree::Example::ArrayNode;
use Tree::Object::Array::Glob qw(id level);

package # hide from PAUSE
    Tree::Example::ArrayNode::Sub1;
use base qw(Tree::Example::ArrayNode);

package # hide from PAUSE
    Tree::Example::ArrayNode::Sub2;
use base qw(Tree::Example::ArrayNode);

package # hide from PAUSE
    Tree::Example::ArrayNode::Sub3;
use base qw(Tree::Example::ArrayNode);

package # hide from PAUSE
    Tree::Example::ArrayNode::Sub4;
use base qw(Tree::Example::ArrayNode);

package # hide from PAUSE
    Tree::Example::ArrayNode::Sub5;
use base qw(Tree::Example::ArrayNode);

package # hide from PAUSE
    Tree::Example::ArrayNode::Sub6;
use base qw(Tree::Example::ArrayNode);

package # hide from PAUSE
    Tree::Example::ArrayNode::Sub7;
use base qw(Tree::Example::ArrayNode);

package # hide from PAUSE
    Tree::Example::InsideoutNode;
use parent qw(Tree::Object::InsideOut);
use Class::InsideOut qw(public);

public id    => my %id;
public level => my %level;

package # hide from PAUSE
    Tree::Example::InsideoutNode::Sub1;
use base qw(Tree::Example::InsideoutNode);

package # hide from PAUSE
    Tree::Example::InsideoutNode::Sub2;
use base qw(Tree::Example::InsideoutNode);

package # hide from PAUSE
    Tree::Example::InsideoutNode::Sub3;
use base qw(Tree::Example::InsideoutNode);

package # hide from PAUSE
    Tree::Example::InsideoutNode::Sub4;
use base qw(Tree::Example::InsideoutNode);

package # hide from PAUSE
    Tree::Example::InsideoutNode::Sub5;
use base qw(Tree::Example::InsideoutNode);

package # hide from PAUSE
    Tree::Example::InsideoutNode::Sub6;
use base qw(Tree::Example::InsideoutNode);

package # hide from PAUSE
    Tree::Example::InsideoutNode::Sub7;
use base qw(Tree::Example::InsideoutNode);

1;
# ABSTRACT:

=head1 SYNOPSIS

 use PERLANCAR::Tree::Examples qw(gen_sample_data);

 my $tree = gen_sample_data(size => 'medium1');


=head1 DESCRIPTION

This distribution can generate sample tree objects of several size (depth +
number of nodes) and implementation (hash-based nodes or array-based). I use
these example trees for benchmarking or testing in several other distributions.

=head2 Overview of available sample data

=over

# CODE: require PERLANCAR::Tree::Examples; require Text::Head; require Tree::Dump; for my $size ('tiny1', 'small1', 'medium1') { for my $backend ('hash', 'array') { print "=item * size=$size, backend=$backend\n\n"; my $s = Text::Head::head_text(text => Tree::Dump::tdmp(PERLANCAR::Tree::Examples::gen_sample_data(size=>$size, backend=>$backend)), hint=>1, lines=>15); $s =~ s/^/ /gm; print $s, "\n" } }

=back


=head1 SEE ALSO

L<dump-perlancar-sample-tree> (L<App::DumpPERLANCARSampleTree>), a simple CLI to
conveniently view the sample data.
